//
//  Database.m
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

#import "Database.h"
#import <CG4_Coursework-Swift.h>
#import "FRDStravaClientImports.h"

#pragma GCC diagnostic ignored "-Wformat-security"

@implementation Database

static Database *_database;

/**
 Ensures a single instance of the class is used throughout the program. If the database already exists it does nothing, otherwise it initialises the class.
 */
+(Database*)init {
    if (_database == nil) {
        _database = [[Database alloc] init];
    }
    return _database;
}

#pragma mark Initialisation
/**
 1. Creates and initialises the class
 2. Finds the directoryPaths
 3. Finds the documents path
 4. Creates the databasePath by appending 'RunDatabase.db' onto documentsPath, storing it as a property of the class
 5. IF no file exists at the datbasePath, call function createDatabaseTables
 */
-(id)init {
    if (self = [super init]) { //1
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //2
        NSString *documentsPath = directoryPaths[0]; //3
        
        self.databasePath = [documentsPath stringByAppendingPathComponent:@"RunDatabase.db"]; //4
        NSLog(self.databasePath);
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.databasePath]) { //5
            [self createDatabaseTables];
        }
        
        [self createDatabaseTables];
    }
    
    return self;
}

/**
 1. Converts the databasePath from an NSString into an array of characters for use with the database
 2. Creates the errorMessage
 3. IF the database opens at the databasePath
 a. Create the SQL
 b. Execute the SQL, storing any errors in errorMessage. IF the SQL does not execute correctly
 i. Log the error message
 c. Closes the database
 4. Else log "Failed to Open Database"
 */
-(void)createDatabaseTables {
    const char *charDbPath = [_databasePath UTF8String]; //1
    char *errorMessage; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        const char *sql = "CREATE TABLE IF NOT EXISTS tblRuns(RunID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, RunDateTime TEXT, RunDistance REAL, RunPace INTEGER, RunDuration INTEGER, RunScore REAL, ShoeID INTEGER)"; //a
        
        if (sqlite3_exec(_database, sql, NULL, NULL, &errorMessage) != SQLITE_OK) { //b
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblRuns; %@", error]); //i
        }
        
        
        const char *sqlSplits = "CREATE TABLE IF NOT EXISTS tblSplits(RunID INTEGER NOT NULL, MileNumber INTEGER NOT NULL, MilePace INTEGER NOT NULL, PRIMARY KEY(RunID, MileNumber))";
        
        if (sqlite3_exec(_database, sqlSplits, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblSplits; %@", error]);
        }
        
        
        const char *sqlLocations = "CREATE TABLE IF NOT EXISTS tblLocations(LocationID INTEGER PRIMARY KEY AUTOINCREMENT, RunID INTEGER, Location TEXT)";
        
        if (sqlite3_exec(_database, sqlLocations, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblLocations; %@", error]);
        }
        
        const char *sqlShoes = "CREATE TABLE IF NOT EXISTS tblShoes(ShoeID INTEGER PRIMARY KEY AUTOINCREMENT, ShoeName TEXT, CurrentMiles REAL, ShoeImagePath TEXT)";
        
        if (sqlite3_exec(_database, sqlShoes, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblShoes; %@", error]);
        }
        
        
        sqlite3_close(_database); //c
        
    } else { //4
        NSLog(@"Failed to open database");
    }
}

#pragma mark - Run Methods

#pragma mark Run Saving
/**
 1. Declares the local variable saveSuccessful as NO
 2. Converts the databasePath from an NSString into an array of characters for use with the database
 3. IF the database opens at the databasePath
 a. Creates the SQL
 b. Converts the SQL to an array of characters for use with the database
 c. Declares an sqlite3 statement
 d. Executes the SQL
 e. IF the statement executes succesfully
 i. Sets saveSuccessful to YES
 ii. Sets the run.ID to the last inserts row ID (this is the run's primary key)
 f. ELSE logs "Error Saving"
 g. Releases the statement
 h. Closes the database
 4. IF the save was successful
 a. IF the run has locations, call saveLocationsForRun function
 b. IF the run has splits, call saveSplitsForRun function
 */
-(void)saveRun:(Run *)run {
    BOOL saveSuccessful = NO; //1
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        NSString *dateTime = [[[Conversions alloc] init]  dateTimeToStringForDB:run.dateTime];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblRuns(RunDateTime, RunDistance, RunPace, RunDuration, RunScore, ShoeID) VALUES('%@', '%1.2f', '%li', '%li', '%1.2f', '%li')", dateTime, run.distance, (long)run.pace, (long)run.duration, run.score, (long)run.shoe.ID]; //a
        
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil); //d
        
        if (sqlite3_step(statement) == SQLITE_DONE) { //e
            saveSuccessful = YES; //i
            run.ID = (NSInteger)sqlite3_last_insert_rowid(_database); //i
            NSLog(@"Saving Succesful"); //iii
        } else { //f
            NSLog(@"Error Saving");
        }
        
        sqlite3_finalize(statement); //g
        
        sqlite3_close(_database);
    }
    
    if (saveSuccessful) { //4
        if (run.locations != nil) { //a
            [self saveLocationsForRun:run];
        }
        
        if (run.splits != nil) { //b
            [self saveSplitsForRun:run];
        }
    }
}

/**
 1. Converts the databasePath from an NSString into an array of characters for use with the database
 2. IF opening the database is successful
 a. FOR each location in the run.locations array
 i. Creates the location coordinates as a string
 ii. Creates the SQL
 iii. Converts the SQL to an array of characters for use with the database
 iv. Declares an sqlite3 statement
 v. Executes the SQL
 vi. IF the statement executes succesfully, log "Saving Successful"
 vii. ELSE log "Error Saving"
 viii. Realeses the statement
 b. Closes the database
 */
-(void)saveLocationsForRun:(Run *)run {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        
        for (CLLocation *location in run.locations) { //a
            NSString *locationCoordinates = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude]; //i
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblLocations(RunID, Location) VALUES ('%li', '%@')", (long)run.ID, locationCoordinates]; //ii
            const char *sqlChar = [sql UTF8String]; //iii
            sqlite3_stmt *statement; //iv
            
            sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil); //v
            
            if (sqlite3_step(statement) == SQLITE_DONE) { //vi
                NSLog(@"Saving Successful");
            } else { //vii
                NSLog(@"Error Saving");
            }
            
            sqlite3_finalize(statement); //viii
            
        } //END FOR
        sqlite3_close(_database); //b
    }
}

/**
 1. Converts the databasePath from an NSString into an array of characters for use with the database
 2. IF opening the database is successful
    a. FOR each split in the run.splits array
        i. Creates the SQL
       ii. Converts the SQL to an array of characters for use with the database
      iii. Declares an sqlite3 statement
       iv. Executes the SQL
        v. IF the statement executes succesfully, log "Saving Successful"
       vi. ELSE log "Error Saving"
      vii. Release the statement
    b. Close the database
 */
-(void)saveSplitsForRun:(Run *)run {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        
        for (int splitNo = 0; splitNo < run.splits.count; splitNo++) { //a
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblSplits(RunID, MileNumber, MilePace) VALUES ('%li', '%i', '%li')", (long)run.ID, splitNo + 1, (long)[run.splits[splitNo] integerValue]]; //i
            
            const char *sqlChar = [sql UTF8String]; //ii
            sqlite3_stmt *statement; //iii
            
            sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil); //iv
            
            if (sqlite3_step(statement) == SQLITE_DONE) { //v
                NSLog(@"Saving Successful");
            } else { //vi
                NSLog(@"Error Saving");
            }
            
            sqlite3_finalize(statement); //vii
        } //END FOR
        sqlite3_close(_database); //b
    }
}

#pragma mark Run Loading

/**
 */
-(NSArray *)loadRunsWithQuery:(NSString *)query {
    NSMutableArray *runs = [[NSMutableArray alloc] init];
    const char *charDbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblRuns %@", query];
        const char *sqlChar = [sql UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int ID = (int)sqlite3_column_int(statement, 0);
                char *dateTimeStr = (char *)sqlite3_column_text(statement, 1);
                double distance = (double)sqlite3_column_double(statement, 2);
                int pace = (int)sqlite3_column_int(statement, 3);
                int duration = (int)sqlite3_column_int(statement, 4);
                double score = (double)sqlite3_column_double(statement, 5);
                
                int shoeID = (int)sqlite3_column_int(statement, 6);
                char *shoeName = (char *)sqlite3_column_text(statement, 7);
                double shoeMiles = (double)sqlite3_column_double(statement, 8);
                char *shoePath = (char *)sqlite3_column_text(statement, 9);
                
                
                //Handle shoes
                NSDate *date = [[[Conversions alloc] init] stringToDateAndTime:[NSString stringWithUTF8String:dateTimeStr]];
                
                
                Run *run = [[Run alloc] initWithRunID:ID distance:distance dateTime:date pace:pace duration:duration shoe:nil runScore:score runLocations:nil runType:@"" splits:nil];
                run.locations = [self loadRunLocationsForRun:run];
                run.splits = [self loadRunSplitsForRun:run];
                [runs addObject:run];
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_database);
        }
    }
    
    runs = [[NSMutableArray alloc] initWithArray: [[[Conversions alloc] init] sortRunsIntoDateOrderWithRuns:runs]];
    
    return runs;
}

/**
 1. Creates and initialises the local mutable array, locations
 2. Converts the databasePath from an NSString into an array of characters for use with the database
 3. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL to an array of characters for use with the database
    c. Declares an SQLite3 statement
    d. Executes the statement, IF it excutes
        i. While there are rows to read
           ii. Retrieves the coordinates of the location from the database as a string
          iii. Creates a CLLocation object using the location string
           iv. Adds the CLLocation object to the array, locations
        v. Release the statement
       vi. Close the database
    e. Else logs "Error Loading Locations"
 4. Returns the locations array
 */
-(NSArray *)loadRunLocationsForRun:(Run *)run {
    NSMutableArray *locations = [[NSMutableArray alloc] init]; //1
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        NSString *sql = [NSString stringWithFormat:@"SELECT Location FROM tblLocations WHERE RunID = %li", (long)run.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) { //d
            while (sqlite3_step(statement) == SQLITE_ROW) { //i
                char *locationStr = (char *)sqlite3_column_text(statement, 0); //ii
                CLLocation *location = [[[Conversions alloc] init] stringToLocation:[NSString stringWithUTF8String:locationStr]]; //iii
                [locations addObject:location]; //iv
            }
            sqlite3_finalize(statement); //v
            sqlite3_close(_database); //vi
        }
    } else { //e
        NSLog(@"Error Loading Locations");
    }
    
    return locations; //4
}

/**
 1. Creates and initialises the local mutable array, splits
 2. Converts the databasePath from an NSString into an array of characters for use with the database
 3. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL to an array of characters for use with the database
    c. Declares an SQLite3 statement
    d. Executes the statement, IF it excutes
        i. While there are rows to read
       ii. Retrieves the mile number
      iii. Retrieves the mile pace
       iv. Adds the milePace to the splits array at the index 1 less than the mile number
    e. Else logs "Error Loading Locations"
 4. Returns the splits array
 */
-(NSArray *)loadRunSplitsForRun:(Run *)run {
    NSMutableArray *splits = [[NSMutableArray alloc] init];
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        NSString *sql = [NSString stringWithFormat:@"SELECT MileNumber, MilePace FROM tblSplits WHERE RunID = %li", (long)run.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) { //d
            while (sqlite3_step(statement) == SQLITE_ROW) { //i
                int mileNumber = sqlite3_column_int(statement, 0); //ii
                int milePace = sqlite3_column_int(statement, 1); //iii
                [splits insertObject:[NSNumber numberWithInt:milePace] atIndex:(mileNumber-1)]; //iv
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    } else { //e
        NSLog(@"Error Loading Splits");
    }
    
    return splits; //4
}

#pragma mark Run Deleting

-(void)deleteRunWithID:(Run *)run {
    const char *charDbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM tblRuns WHERE RunID = '%li'", (long)run.ID];
        const char *sqlChar = [sql UTF8String];
        char *errorMessage;
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error deleting run: %@", error]);
        } else {
            NSLog(@"Run Deleted Successfully");
        }
    }
}

#pragma mark - Plan Methods
#pragma mark Plan Saving

#pragma mark - Shoe Methods
#pragma mark Shoe Saving

-(void)saveShoe:(Shoe *)shoe {
    const char *charDbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblShoes(ShoeName, CurrentMiles, ShoeImagePath) VALUES ('%@', '%1.2f', '%@')", shoe.name, shoe.miles, shoe.imagePath];
        const char *sqlChar = [sql UTF8String];
        sqlite3_stmt *statement;
        
        sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Saving Successful");
        } else {
            NSLog(@"Error Saving");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
}

-(void)updateShoeMiles:(Shoe *)shoe {
    const char *charDbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE tblShoes SET CurrentMiles = '%1.2f' WHERE ShoeID = '%li'", shoe.miles, (long)shoe.ID];
        const char *sqlChar = [sql UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"Saving Successful");
            } else {
                NSLog(@"Error Saving");
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }
}


#pragma mark Shoe Loading

-(NSArray *)loadShoes {
    NSMutableArray *shoes = [[NSMutableArray alloc] init];

    
    return shoes;
}

@end
