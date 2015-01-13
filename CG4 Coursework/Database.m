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
        const char *sql = "CREATE TABLE IF NOT EXISTS tblRuns(RunID INTEGER PRIMARY KEY AUTOINCREMENT, RunDate TEXT, RunTime TEXT, RunDistance REAL, RunPace INTEGER, RunDuration INTEGER, RunScore REAL, ShoeID INTEGER)"; //a
        
        if (sqlite3_exec(_database, sql, NULL, NULL, &errorMessage) != SQLITE_OK) { //b
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblRuns, %@", error]); //i
        }
        
        
        const char *sqlSplits = "CREATE TABLE IF NOT EXISTS tblSplits(RunID INTEGER NOT NULL, MileNumber INTEGER NOT NULL, MilePace INTEGER NOT NULL, PRIMARY KEY(RunID, MileNumber))";
        
        if (sqlite3_exec(_database, sqlSplits, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblSplits, %@", error]);
        }
        
        
        const char *sqlLocations = "CREATE TABLE IF NOT EXISTS tblLocations(LocationID INTEGER PRIMARY KEY AUTOINCREMENT, RunID INTEGER, Location TEXT)";
        
        if (sqlite3_exec(_database, sqlLocations, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblLocations, %@", error]);
        }
        
        const char *sqlShoes = "CREATE TABLE IF NOT EXISTS tblShoes(ShoeID INTEGER PRIMARY KEY AUTOINCREMENT, ShoeName TEXT, CurrentMiles REAL, ShoeImagePath TEXT)";
        
        if (sqlite3_exec(_database, sqlShoes, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblShoes, %@", error]);
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
        NSString *date = [[[Conversions alloc] init] dateToString:run.dateTime];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblRuns(RunDate, RunTime, RunDistance, RunPace, RunDuration, RunScore, ShoeID) VALUES('%@', '%s', '%1.2f', '%li', '%li', '%1.2f', '%li')", date, "time", run.distance, (long)run.pace, (long)run.duration, run.score, (long)run.shoe.ID]; //a
        
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

-(NSArray *)loadAllRuns {
    NSMutableArray *runs = [[NSMutableArray alloc] init];
    const char *charDbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) {
        const char *sqlChar = "SELECT * FROM tblRuns";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int ID = (int)sqlite3_column_int(statement, 0);
                char *dateStr = (char *)sqlite3_column_text(statement, 1);
                char *timeStr = (char *)sqlite3_column_text(statement, 2);
                double distance = (double)sqlite3_column_double(statement, 3);
                int pace = (int)sqlite3_column_int(statement, 4);
                int duration = (int)sqlite3_column_int(statement, 5);
                double score = (double)sqlite3_column_double(statement, 6);
                int shoeID = (int)sqlite3_column_int(statement, 7);
                char *shoeName = (char *)sqlite3_column_text(statement, 8);
                double shoeMiles = (double)sqlite3_column_double(statement, 9);
                char *shoePath = (char *)sqlite3_column_text(statement, 10);
                
                NSDate *date = [[[Conversions alloc] init] stringToDateAndTime:[NSString stringWithUTF8String:dateStr] timeStr:[NSString stringWithUTF8String:timeStr]];
            }
        }
    }
    
    return runs;
}

-(Run *)loadRunWithDate:(NSDate *)date {
    Run *run = [[Run alloc] init];
    
    return run;
}

-(Run *)loadMostRecentRun {
    Run *run = [[Run alloc] init];
    
    return run;
}

#warning "unfinished method"

//load shoes with an image path, load image only when needed
-(NSArray *)loadRunsForMonth:(NSString *)month {
    Conversions *converter = [[Conversions alloc] init];
    NSMutableArray *runs = [[NSMutableArray alloc] init];
    const char *charDbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblRuns WHERE RunDate LIKE '___%@%%'", month];
        const char *sqlChar = [sql UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int ID = (int)sqlite3_column_int(statement, 0);
                char *dateStr = (char *)sqlite3_column_text(statement, 1);
                char *timeStr = (char *)sqlite3_column_text(statement, 2);
                timeStr = "15:33:26";
                double distance = (double)sqlite3_column_double(statement, 3);
                int pace = (int)sqlite3_column_int(statement, 4);
                int duration = (int)sqlite3_column_int(statement, 5);
                double score = (double)sqlite3_column_double(statement, 6);
                int shoeID = (int)sqlite3_column_int(statement, 7);
                shoeID = 1;
                char *shoeName = (char *)sqlite3_column_text(statement, 8);
                shoeName = "New Balance";
                double shoeMiles = (double)sqlite3_column_double(statement, 9);
                shoeMiles = 192.5;
                char *shoePath = (char *)sqlite3_column_text(statement, 10);
                shoePath = "path";
                
                NSDate *date = [converter stringToDateAndTime:[NSString stringWithUTF8String:dateStr] timeStr:[NSString stringWithUTF8String:timeStr]];
                
                Shoe *runShoe;
                if (shoeID != 0) {
                    runShoe = [[Shoe alloc] initWithID:shoeID name:[NSString stringWithUTF8String:shoeName] miles:shoeMiles imagePath:[NSString stringWithUTF8String:shoePath]];
                } else {
                    runShoe = nil;
                }

                Run *run = [[Run alloc] initWithRunID:ID distance:distance dateTime:date pace:pace duration:duration shoe:runShoe runScore:score runLocations:nil runType:@"" splits:nil];
                run.locations = [self loadRunLocationsForRun:run];
                run.splits = [self loadRunSplitsForRun:run];
                [runs addObject:run];
            }
            sqlite3_finalize(statement); //vii
            sqlite3_close(_database);
        }
    }
    
    return runs;
}


-(NSArray *)loadRunsForYear:(NSString *)year {
    NSMutableArray *runs = [[NSMutableArray alloc] init];
    
    
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
           ii. Declares the local variables latitude and longitude
          iii. Retrieves the coordinates of the location from the database as a string
           iv. Splits the string based on the criteria of "double, double" storing the parts in latitude and longitude
            v. Creates a CLLocation object using the latitude and longitude
           vi. Adds the CLLocation object to the array, locations
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
                double latitude, longitude; //ii
                char *locationStr = (char *)sqlite3_column_text(statement, 0); //iii
                sscanf(locationStr, "%lf, %lf", &latitude, &longitude); //iv
                CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude]; //v
                [locations addObject:location]; //vi
            }
            sqlite3_finalize(statement); //vii
            sqlite3_close(_database);
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
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM tblRuns  WHERE RunID = '%li'", (long)run.ID];
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
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        //a
            //i
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblShoes(ShoeName, CurrentMiles, ShoeImagePath) VALUES ('%@', '%1.2f', '%@')", shoe.name, shoe.miles, shoe.imagePath]; //ii
        const char *sqlChar = [sql UTF8String];
        sqlite3_stmt *statement; //iii
            
        sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil); //iv
            
        if (sqlite3_step(statement) == SQLITE_DONE) { //v
            NSLog(@"Saving Successful");
        } else { //vi
            NSLog(@"Error Saving");
        }
            
        sqlite3_finalize(statement); //vii
        sqlite3_close(_database); //b
    }
}


#pragma mark Shoe Loading

-(NSArray *)loadShoes {
    NSMutableArray *shoes = [[NSMutableArray alloc] init];

    
    return shoes;
}

@end
