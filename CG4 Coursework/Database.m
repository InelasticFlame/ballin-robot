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

/* 
 The following units are used in the database:
    Distance: Miles
    Average Pace: Seconds Per Mile
    Run Duration: Seconds
*/

static Database *_database; //A global variable that stores the current instance of the Database class

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
        
        #warning Testing Only
        [self createDatabaseTables];
    }
    
    return self;
}

/**
 1. Converts the databasePath from an NSString into a pure string for use with the database
 2. Creates the errorMessage
 3. IF the database opens at the databasePath
    a. Create the SQL
    b. Execute the SQL, storing any errors in errorMessage. IF the SQL does not execute correctly
        i. Log the error message
    c. Repeats this process for the other tables
    d. Closes the database
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
        
        //c
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
        
        const char *sqlPlans = "CREATE TABLE IF NOT EXISTS tblTrainingPlans(PlanID INTEGER PRIMARY KEY AUTOINCREMENT, PlanName TEXT, StartDate TEXT, EndDate TEXT)";
        
        if (sqlite3_exec(_database, sqlPlans, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblTrainingPlans; %@", error]);
        }
        
        const char *sqlPlannedRuns = "CREATE TABLE IF NOT EXISTS tblPlannedRuns(PlannedRunID INTEGER PRIMARY KEY AUTOINCREMENT, PlannedDate TEXT, RunDistance REAL, RunDuration INTEGER, Details TEXT, PlanID INTEGER NOT NULL)";
        
        if (sqlite3_exec(_database, sqlPlannedRuns, NULL, NULL, &errorMessage) != SQLITE_OK) {
            NSString *error = [NSString stringWithUTF8String:errorMessage];
            NSLog([NSString stringWithFormat:@"Error creating tblPlannedRuns; %@", error]);
        }
        
        sqlite3_close(_database); //d
        
    } else { //4
        NSLog(@"Failed to open database");
    }
}

#pragma mark - Run Methods

#pragma mark Run Saving
/**
 1. Declares the local variable saveSuccessful as NO
 2. Converts the databasePath from an NSString into a pure string for use with the database
 3. IF the database opens at the databasePath
    a. Creates the SQL
    b. Converts the SQL to an array of characters for use with the database
    c. Declares an sqlite3 statement
    d. Executes the SQL
    e. IF the statement executes succesfully
        i. Sets saveSuccessful to YES
       ii. Sets the run.ID to the last inserts row ID (this is the run's primary key)
      iii. Calls the function checkRunForNewPersonalBest passing the run
       iv. Logs "Saving Successful"
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
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblRuns(RunDateTime, RunDistance, RunPace, RunDuration, RunScore, ShoeID) VALUES('%@', '%1.2f', '%li', '%li', '%1.2f', '%li')", run.dateTime.databaseString, run.distance, (long)run.pace, (long)run.duration, run.score, (long)run.shoe.ID]; //a
        
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil); //d
        
        if (sqlite3_step(statement) == SQLITE_DONE) { //e
            saveSuccessful = YES; //i
            run.ID = (NSInteger)sqlite3_last_insert_rowid(_database); //ii
            [self checkRunForNewPersonalBest:run]; //iii
            NSLog(@"Saving Succesful"); //iv
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
 1. Converts the databasePath from an NSString into a pure string for use with the database
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
 1. Converts the databasePath from an NSString into a pure string for use with the database
 2. IF opening the database is successful
    a. FOR each split in the run.splits array
        i. Creates the SQL
       ii. Converts the SQL to characters for use with the database
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

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Declares the local NSString variable sql
    b. IF there is a shoe; sets the SQL to UPDATE tblRuns SET ShoeID = 'shoeID' WHERE RunID = 'runID'
    c. ELSE sets the SQL to UPDATE tblRuns SET ShoeID = '0' WHERE RunID = 'runID' (0 indicates no shoe)
    d. Converts the SQL to characters for use with the database
    e. Declares the local char variable errorMessage
    f. IF the SQL does not execute successfully
        i. Logs "Shoe saved to run successfully"
       ii. Closes the database
      iii. Returns YES (true)
    g. ELSE
        i. Logs "Error saving shoe to run" 
       ii. Closes the database
      iii. Returns NO (false)
  3. Logs "Error opening database"
  4. Returns NO (false)
 */
-(BOOL)saveShoe:(Shoe *)shoe ToRun:(Run *)run {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql; //a
        
        if (shoe != nil) { //b
            sql = [NSString stringWithFormat:@"UPDATE tblRuns SET ShoeID = '%li' WHERE RunID = '%li'", (long)shoe.ID, (long)run.ID];
        } else { //c
            sql = [NSString stringWithFormat:@"UPDATE tblRuns SET ShoeID = '0' WHERE RunID = '%li'", (long)run.ID];
        }
        
        const char *sqlChar = [sql UTF8String]; //d
        char *errorMessage; //e
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) == SQLITE_OK) { //f
            NSLog(@"Shoe saved to run successfully"); //i
            sqlite3_close(_database); //ii
            return YES; //iii
        } else { //g
            NSLog(@"Error saving shoe to run"); //i
            sqlite3_close(_database); //ii
            return NO; //iii
        }
    }
    
    NSLog(@"Error opening database"); //3
    return NO; //4
}

 /**
  1. Initialises the local user defautls and stores it in the local variable userDefaults
  2. Retrieves the longest distance personal best
  3. Retrieves the longest duration personal best
  4. Retrieves the fastest mile personal best
  5. Retrieves the fastest average pace personal best
  6. IF the run distance is greater than the longest distance
    a. Update the longest distance personal best to the run distance
  7. IF the run duration is longer than the longest duration
    a. Update the longest duration personal best to the run duration
  8. IF the run pace is faster (less than) the fastest average pace
    a. Update the fastest average pace personal best to the run pace
  9. FOR each run in the array of run splits
    a. IF the run split has a pace faster (less than) the fastest mile
        i. Set the fastest mile to the run split pace
       ii. Update the fastest mile personal best to the run split pace
 */
-(void)checkRunForNewPersonalBest:(Run *)run {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; //1
    double longestDistance = [userDefaults doubleForKey: [ObjConstants longestDistanceKey]]; //2
    NSInteger longestDuration = [userDefaults integerForKey:[ObjConstants longestDurationKey]]; //3
    NSInteger fastestMile = [userDefaults integerForKey:[ObjConstants fastestMileKey]]; //4
    NSInteger fastestAvgPace = [userDefaults integerForKey:[ObjConstants fastestAvgPaceKey]]; //5
 
    if (run.distance > longestDistance) { //6
        [userDefaults setDouble:run.distance forKey:[ObjConstants longestDistanceKey]]; //a
    }
    if (run.duration > longestDuration) { //7
        [userDefaults setInteger:run.duration forKey:[ObjConstants longestDurationKey]]; //a
    }
    if ((run.pace < fastestAvgPace) || (fastestAvgPace == 0)) { //8
        [userDefaults setInteger:run.pace forKey:[ObjConstants fastestAvgPaceKey]]; //a
    }
    
    for (int i = 0; i < run.splits.count; i++) { //9
        if (((long)[run.splits[i] integerValue] < fastestMile) || (fastestMile == 0)) { //a
            fastestMile = (long)[run.splits[i] integerValue]; //i
            [userDefaults setInteger:fastestMile forKey:[ObjConstants fastestMileKey]]; //ii
        }
    }
    
}

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. Calls the function loadRunsWithQuery and loading all runs where the ShoeID is the shoe to be removed, storing the returned runs in the constant array runsWithShoe
  3. IF the database opens successfuly
    a. IF there are any runs stored with this shoe
        i. Retrieves the first run from the array storing it as firstRun to build the first part of the SQL
       ii. Creates the first part of the SQL
      iii. FOR each other shoe in the array runsWithShoe
            iv. Appends " OR RunID = 'run ID'" to the SQL
        v. Converts the SQL into a pure string for use with the database
       vi. Declares the local char variable errorMessage
      vii. IF the SQL does not execute successfully
            A. Converts the error message to an NSString
            B. Logs "Error removing shoe from runs: " and the error message
            C. Closes the database
            D. Returns NO (false)
     viii. ELSE
            A. Logs "Shoe successfully removed from runs"
            B. Closes the database
            C. Returns YES (true)
    b. ELSE returns YES (true)
  4. ELSE returns NO (false)
 */
-(BOOL)removeShoeFromRuns:(Shoe *)shoe {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    NSArray *runsWithShoe = [self loadRunsWithQuery:[NSString stringWithFormat:@"WHERE ShoeID = '%li'", (long)shoe.ID]]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        if (runsWithShoe.count > 0) { //a
            Run *firstRun = (Run *)runsWithShoe.firstObject; //i
            NSString *sql = [NSString stringWithFormat:@"UPDATE tblRuns SET ShoeID = '0' WHERE RunID = '%li'", (long)firstRun.ID]; //ii
            
            for (int runShoeNo = 1; runShoeNo < runsWithShoe.count; runShoeNo++) { //iii
                Run *run = (Run *)runsWithShoe[runShoeNo];
                [sql stringByAppendingString:[NSString stringWithFormat:@" OR RunID = '%li'", (long)run.ID]]; //iv
            }
            
            const char *sqlChar = [sql UTF8String]; //v
            char *errorMessage; //vi
            
            if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //vii
                NSString *error = [NSString stringWithUTF8String:errorMessage]; //A
                NSLog([NSString stringWithFormat:@"Error removing shoe from runs: %@", error]); //B
                sqlite3_close(_database); //C
                return NO; //D
            } else { //viii
                NSLog(@"Shoe successfully removed from runs"); //A
                sqlite3_close(_database); //B
                return YES; //C
            }
        } else { //b
            return YES;
        }
    } else { //4
        return NO;
    }
}

#pragma mark Run Loading

 /**
  1. Creates and initialises the local mutable array, runs
  2. Converts the databasePath from an NSString into a pure string for use with the database
  3. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL into a pure string to use with the database
    c. Declares an SQLite3 statement
    d. Executes the statement, IF it executes successfully
        i. While there are rows to read
       ii. Retrieves the runID as an integer from the first column in the database
      iii. Retrieves the run date/time as a char from the second column in the database
       iv. Retrieves the distance as a double from the third column in the database
        v. Retrieves the pace as an integer from the fourth column in the database
       vi. Retrieves the duration as an integer from the fifth column in the database
      vii. Retrieves the run score as a double from the sixth column in the database
     viii. Retrieves the shoeID as an integer from the seventh column in the database
       ix. Creates the local variable runShoe by calling the function loadShoeWithID by passing the shoeID retrieved from the database
        x. Creates the run date using the initWithDatabaseString method
       xi. Creates and initialises the run object
      xii. Loads the locations for the run by calling the function loadRunLocationsForRun
     xiii. Loads the splits for the run by calling the function loadSplitsForRun
      xiv. Adds the new run to the runs array
    e. Releases the statement
    f. Closes the database
  4. ELSE logs "Error Opening Database"
  5. Sorts the runs into date order
  6. Returns the array of runs
 */
-(NSArray *)loadRunsWithQuery:(NSString *)query {
    NSMutableArray *runs = [[NSMutableArray alloc] init]; //1
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblRuns %@", query]; //a
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) { //d
            while (sqlite3_step(statement) == SQLITE_ROW) { //i
                int ID = (int)sqlite3_column_int(statement, 0); //ii
                char *dateTimeStr = (char *)sqlite3_column_text(statement, 1); //iii
                double distance = (double)sqlite3_column_double(statement, 2); //iv
                int pace = (int)sqlite3_column_int(statement, 3); //v
                int duration = (int)sqlite3_column_int(statement, 4); //vi
                double score = (double)sqlite3_column_double(statement, 5); //vii
                int shoeID = (int)sqlite3_column_int(statement, 6); //viii
                
                Shoe *runShoe = [self loadShoeWithID:shoeID]; //ix
                NSDate *date = [[NSDate alloc] initWithDatabaseString:[NSString stringWithUTF8String:dateTimeStr]]; //x
                
                
                Run *run = [[Run alloc] initWithRunID:ID distance:distance dateTime:date pace:pace duration:duration shoe:runShoe runScore:score runLocations:nil splits:nil]; //xi
                run.locations = [self loadRunLocationsForRun:run]; //xii
                run.splits = [self loadRunSplitsForRun:run]; //xiii
                
                [runs addObject:run]; //xiv
            }
            
            sqlite3_finalize(statement); //e
            sqlite3_close(_database); //f
        }
    } else { //4
        NSLog(@"Error Opening Database");
    }
    
    runs = [[NSMutableArray alloc] initWithArray: [[[Conversions alloc] init] sortRunsIntoDateOrderWithRuns:runs]]; //5
    
    return runs; //6
}

 /**
 1. Creates and initialises the local mutable array, locations
 2. Converts the databasePath from an NSString into a pure string for use with the database
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
                CLLocation *location = [[CLLocation alloc] initWithLocationString:[NSString stringWithUTF8String:locationStr]]; //iii
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
 2. Converts the databasePath from an NSString into a pure string for use with the database
 3. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL to an array of characters for use with the database
    c. Declares an SQLite3 statement
    d. Executes the statement, IF it excutes
        i. While there are rows to read
       ii. Retrieves the mile number
      iii. Retrieves the mile pace
       iv. Adds the milePace to the splits array at the index 1 less than the mile number
    e. Releases the statement
    f. Closes the database
    g. Else logs "Error Loading Locations"
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
        sqlite3_finalize(statement); //e
        sqlite3_close(_database); //f
    } else { //g
        NSLog(@"Error Loading Splits");
    }
    
    return splits; //4
}

#pragma mark Run Deleting

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL to an array of characters for use with the database
    c. Declares the local char variable errorMessage
    d. IF the sql doesn't execute successfully
        i. Retrieves the error message as an NSString
       ii. Logs "Error deleting run: " and the error message
      iii. Closes the database
       iv. Returns NO (false)
    e. ELSE
        i. Logs "Run Deleted Successfully"
       ii. Closes the database
      iii. Retruns YES (true)
  3. ELSE logs "Error Opening Database" and returns NO (false)
  */
-(BOOL)deleteRunWithID:(Run *)run {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM tblRuns WHERE RunID = '%li'; DELETE FROM tblLocations WHERE RunID = '%li'; DELETE FROM tblSplits WHERE RunID = '%li'", (long)run.ID, (long)run.ID, (long)run.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSString *error = [NSString stringWithUTF8String:errorMessage]; //i
            NSLog([NSString stringWithFormat:@"Error deleting run: %@", error]); //ii
            sqlite3_close(_database); //iii
            return  NO; //iv
        } else { //e
            NSLog(@"Run Deleted Successfully"); //i
            sqlite3_close(_database); //ii
            return YES; //iii
        }
    } else { //3
        NSLog(@"Error Opening Database");
        return NO;
    }
}

#pragma mark - Plan Methods
#pragma mark Plan Saving

/**
 1. Declares the local variables planID, an NSInteger and the plan an new Plan object
 2. Converts the databasePath from an NSString into a pure string for use with the database
 3. IF the database opens successfully
    a. Creates the SQL
    b. Converts the SQL to an array of characters for use with the database
    c. Declares the local variable errorMessage to store any errors from the database
    d. IF the SQL does not execute successfully
        i. Logs "Error Saving: " followed by the error message from the database
    e. ELSE
        i. Retrieves the planID of the plan just created (this is the rowID of the last insert)
       ii. Creates a new plan, with the planID the name, the startDate and the endDate
      iii. Logs "Plan Saving Successful"
       iv. Returns the plan
    f. Closes the database
 4. ELSE Logs "Error Opening Database"
 5. Returns nil as the default case
 */
-(Plan *)createNewPlanWithName:(NSString*)name startDate:(NSDate*)startDate andEndDate:(NSDate*)endDate {
    NSInteger planID; //1
    Plan *plan;
    
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblTrainingPlans(PlanName, StartDate, EndDate) VALUES ('%@', '%@', '%@')", name, startDate.shortDateString, endDate.shortDateString]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
                NSLog(@"Error Creating Plan: %@", [NSString stringWithUTF8String:errorMessage]); //i
        } else { //e
            planID = (NSInteger)sqlite3_last_insert_rowid(_database); //i
            plan = [[Plan alloc] initWithID:planID name:name startDate:startDate endDate:endDate]; //ii
            NSLog(@"Plan Creation Successful"); //iii
            return plan; //iv
        }
        
        sqlite3_close(_database); //f
    } else { //4
        NSLog(@"Error Opening Database");
    }
    
    return nil; //5
}

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF the database opens successfully
    a. Creates the SQL
    b. Converts the SQL to an array of characters for use with the database
    c. Declares the local variable errorMessage to store any errors from the database
    d. IF the SQL does not execute successfully
        i. Logs "Error saving planned run: " and the error message
       ii. Closes the database
      iii. Returns NO (false)
    e. ELSE
        i. Logs "Planned Run Successfully Saved."
       ii. Closes the database
      iii. Returns YES (true)
  3. ELSE logs "Error opening database" and Retruns NO (false)
 */
-(BOOL)savePlannedRun:(PlannedRun *)plannedRun ForPlan:(Plan *)plan {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblPlannedRuns(PlannedDate, RunDistance, RunDuration, Details, PlanID) VALUES ('%@', '%1.2f', '%li', '%@', %li)", plannedRun.date.shortDateString, plannedRun.distance, (long)plannedRun.duration, plannedRun.details, (long)plan.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSLog(@"Error Saving Planned Run: %@", [NSString stringWithUTF8String:errorMessage]); //i
            sqlite3_close(_database); //ii
            return NO; //iii
        } else { //e
            NSLog(@"Planned Run Successfully Saved."); //i
            sqlite3_close(_database); //ii
            return YES; //iii
        }
    } else { //3
        NSLog(@"Error Opening Database");
        return NO;
    }
}

#pragma mark Plan Loading

 /**
  1. Creates and initialises the local mutable array, trainingPlans
  2. Converts the databasePath from an NSString into a pure string for use with the database
  3. IF opening the database is successful
    a. Creates the SQL as a constant char
    b. Declares an SQLite3 statement
    c. Executes the statement, IF it executes successfully
        i. While there are rows to read
           ii. Retrieves the planID as an integer from the first column in the database
          iii. Retrieves the plan name as a char from the second column in the database
           iv. Retrieves the start date as a char from the third column in the database
            v. Retrieves the end date as a char from the fourth column in the database
           vi. Converts the start date into an NSDate using the initWithShortDate initialiser
          vii. Converts the end date into an NSDate using the initWithShortDate initialiser
         viii. Creates and initialises the plan object
           ix. Adds the new plan to the array trainingPlans
    d. Releases the statement
    e. Closes the database
  4. ELSE logs "Error Opening Database"
  5. Returns the trainingPlans array
 */
-(NSArray *)loadAllTrainingPlans {
    NSMutableArray *trainingPlans = [[NSMutableArray alloc] init]; //1
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        const char *sqlChar = "SELECT * FROM tblTrainingPlans"; //a
        sqlite3_stmt *statement; //b
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) { //c
            while (sqlite3_step(statement) == SQLITE_ROW) { //i
                int planID = (int)sqlite3_column_int(statement, 0); //ii
                char *name = (char *)sqlite3_column_text(statement, 1); //iii
                char *startDateStr = (char *)sqlite3_column_text(statement, 2); //iv
                char *endDateStr = (char *)sqlite3_column_text(statement, 3); //v
                
                NSDate *startDate = [[NSDate alloc] initWithShortDateString:[NSString stringWithUTF8String:startDateStr]]; //vi
                NSDate *endDate = [[NSDate alloc] initWithShortDateString:[NSString stringWithUTF8String:endDateStr]]; //vii
                
                Plan *plan = [[Plan alloc] initWithID:planID name:[NSString stringWithUTF8String:name] startDate:startDate endDate:endDate]; //viii
                [trainingPlans addObject:plan]; //ix
            }
        }
        sqlite3_finalize(statement); //d
        sqlite3_close(_database); //e

    } else { //4
        NSLog(@"Error Opening Database");
    }
    
    return trainingPlans; //5
}

 /**
  1. Creates and initialises the local mutable array, plannedRuns
  2. Converts the databasePath from an NSString into a pure string for use with the database
  3. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL into a pure string to use with the database
    c. Declares an SQLite3 statement
    d. Executes the statement, IF it executes successfully
        i. While there are rows to read
       ii. Retrieves the plannedRunID as an integer from the first column in the database
      iii. Retrieves the planned date as a char from the second column in the database
       iv. Retrieves the distance as a double from the third column in the database
        v. Retrieves the duration as an integer from the fourth column in the database
       vi. Retrieves the planned details as a char from the fifth column in the database
      vii. Creates and initialises the planned run object
     viii. Adds the new planned run to the array plannedRuns
  e. Releases the statement
  f. Closes the database
 4. ELSE logs "Error Opening Database"
 5. Returns the plannedRuns array
 */
-(NSArray *)loadPlannedRunsForPlan:(Plan *)plan {
    NSMutableArray *plannedRuns = [[NSMutableArray alloc] init]; //1
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblPlannedRuns WHERE PlanID = '%li'", (long)plan.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) { //d
            while (sqlite3_step(statement) == SQLITE_ROW) { //i
                int plannedRunID = (int)sqlite3_column_int(statement, 0); //ii
                char *plannedDateStr = (char *)sqlite3_column_text(statement, 1); //iii
                double distance = (double)sqlite3_column_double(statement, 2); //iv
                int duration = (int)sqlite3_column_int(statement, 3); //v
                char *details = (char *)sqlite3_column_text(statement, 4); //vi
                
                PlannedRun *plannedRun = [[PlannedRun alloc] initWithID:plannedRunID date:[[NSDate alloc] initWithShortDateString:[NSString stringWithUTF8String:plannedDateStr]] distance: distance duration:duration details:[NSString stringWithUTF8String:details]]; //vii
                [plannedRuns addObject:plannedRun]; //viii
            }
        }
        sqlite3_finalize(statement); //e
        sqlite3_close(_database); //f
        
    } else { //4
        NSLog(@"Error Opening Database");
    }
    
    return plannedRuns; //5
}

#pragma mark Plan Deleting

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL into a pure string to use with the database
    c. Declares the local char variable errorMessage
    d. IF the SQL does not execute successfully
        i. Convert the error message into an NSString
       ii. Log "Error deleting plan: " and the error message
      iii. Closes the database
       iv. Returns NO (false)
    e. ELSE
        i. Logs "Plan Deleted Successfully"
       ii. Closes the database
      iii. Calls the function deletePlannedRunsForPlan return the boolean returned by that function
  3. ELSE logs "Error Opening Database"
  4. Returns NO (false)
 */
-(BOOL)deletePlan:(Plan *)plan {
    const char *charDbPath = [_databasePath UTF8String]; //1
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM tblTrainingPlans WHERE PlanID = '%li'", (long)plan.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSString *error = [NSString stringWithUTF8String:errorMessage]; //i
            NSLog([NSString stringWithFormat:@"Error deleting plan: %@", error]); //ii
            sqlite3_close(_database); //iii
            return  NO; //iv
        } else { //e
            NSLog(@"Plan Deleted Successfully"); //i
            sqlite3_close(_database); //ii
            return [self deletePlannedRunsForPlan:plan]; //iii
        }
    } else { //3
        NSLog(@"Error Opening Database");
    }
    
    return NO; //4
}

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL into a pure string to use with the database
    c. Declares the local char variable errorMessage
    d. IF the SQL does not execute successfully
        i. Convert the error message into an NSString
       ii. Log "Error deleting planned runs: " and the error message
      iii. Closes the database
       iv. Returns NO (false)
    e. ELSE
        i. Logs "Planned Runs Deleted Successfully"
       ii. Closes the database
      iii. Returns YES (true)
 3. ELSE logs "Error Opening Database"
 4. Returns NO (false)
 */
-(BOOL)deletePlannedRunsForPlan:(Plan *)plan {
    const char *charDbPath = [_databasePath UTF8String]; //1
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM tblPlannedRuns WHERE PlanID = '%li'", (long)plan.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSString *error = [NSString stringWithUTF8String:errorMessage]; //i
            NSLog([NSString stringWithFormat:@"Error deleting planned runs: %@", error]); //ii
            sqlite3_close(_database); //iii
            return  NO; //iv
        } else { //e
            NSLog(@"Planned Runs Deleted Successfully"); //i
            sqlite3_close(_database); //ii
            return YES; //iii
        }
    } else { //3
        NSLog(@"Error Opening Database");
    }
    
    return NO; //4
}

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL into a pure string to use with the database
    c. Declares the local char variable errorMessage
    d. IF the SQL does not execute successfully
        i. Convert the error message into an NSString
       ii. Log "Error deleting planned run: " and the error message
      iii. Closes the database
       iv. Returns NO (false)
    e. ELSE
        i. Logs "Planned Run Deleted Successfully"
       ii. Closes the database
      iii. Returns YES (true)
 3. ELSE logs "Error Opening Database"
 4. Returns NO (false)
 */
-(BOOL)deletePlannedRun:(PlannedRun *)plannedRun {
    const char *charDbPath = [_databasePath UTF8String]; //1
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM tblPlannedRuns WHERE PlannedRunID = '%li'", (long)plannedRun.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSString *error = [NSString stringWithUTF8String:errorMessage]; //i
            NSLog([NSString stringWithFormat:@"Error deleting planned run: %@", error]); //ii
            sqlite3_close(_database); //iii
            return  NO; //iv
        } else { //e
            NSLog(@"Planned Run Deleted Successfully"); //i
            sqlite3_close(_database); //ii
            return YES; //iii
        }
    } else { //3
        NSLog(@"Error Opening Database");
    }
    
    return NO; //4
}

#pragma mark - Shoe Methods
#pragma mark Shoe Saving

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Creates the SQL as an NSString
    b. Converts the SQL into a pure string to use with the database
    c. Declares an SQLite3 statement
    d. Executes the statement
    e. IF the statement executes succesfully
        i. Logs "Shoe Saved Successfully"
    f. ELSE
        i. Logs "Error Saving Shoe"
    g. Releases the statement
    h. Closes the database
  3. ELSE logs "Error Opening Database"
 */
-(void)saveShoe:(Shoe *)shoe {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblShoes(ShoeName, CurrentMiles, ShoeImagePath) VALUES ('%@', '%1.2f', '%@')", shoe.name, shoe.miles, shoe.imageName]; //a
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil); //d
        
        if (sqlite3_step(statement) == SQLITE_DONE) { //e
            NSLog(@"Shoe Saved Successfully"); //i
        } else { //f
            NSLog(@"Error Saving Shoe"); //i
        }
        
        sqlite3_finalize(statement); //g
        sqlite3_close(_database); //h
    } else { //3
        NSLog(@"Error Opening Database");
    }
}

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Creates the SQL as an NSString
    b. Converts the SQL into a pure string to use with the database
    c. Declares the local char variable errorMessage
    d. IF the statement does not execute succesfully
        i. Converts the errorMessage to an NSString
       ii. Logs "Error increasing shoe miles: " and the error message
    e. ELSE
        i. Logs "Shoe miles increased successfully"
    f. Closes the database
  3. ELSE logs "Error Opening Database"
 */
-(void)increaseShoeMiles:(Shoe *)shoe byAmount:(double)amount {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"UPDATE tblShoes SET CurrentMiles = '%1.2f' WHERE ShoeID = '%li'", shoe.miles + amount, (long)shoe.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSString *error = [NSString stringWithUTF8String:errorMessage]; //i
            NSLog([NSString stringWithFormat:@"Error increasing shoe miles: %@", error]); //ii
        } else { //e
            NSLog(@"Shoe miles increased successfully"); //i
        }

        sqlite3_close(_database); //f
    } else { //3
        NSLog(@"Error Opening Database");
    }
}

/**
 1. Converts the databasePath from an NSString into a pure string for use with the database
 2. IF opening the database is successful
    a. Creates the SQL as an NSString
    b. Converts the SQL into a pure string to use with the database
    c. Declares the local char variable errorMessage
    d. IF the statement does not execute succesfully
        i. Converts the errorMessage to an NSString
       ii. Logs "Error decreasing shoe miles: " and the error message
    e. ELSE
        i. Logs "Shoe miles decreased successfully"
    f. Closes the database
 3. ELSE logs "Error Opening Database"
 */
-(void)decreaseShoeMiles:(Shoe *)shoe byAmount:(double)amount {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"UPDATE tblShoes SET CurrentMiles = '%1.2f' WHERE ShoeID = '%li'", shoe.miles - amount, (long)shoe.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSString *error = [NSString stringWithUTF8String:errorMessage]; //i
            NSLog([NSString stringWithFormat:@"Error decreasing shoe miles: %@", error]); //ii
        } else { //e
            NSLog(@"Shoe miles decreased successfully"); //i
        }
        
        sqlite3_close(_database); //f
    } else {
        NSLog(@"Error Opening Database"); //3
    }
}


#pragma mark Shoe Loading

 /**
  1. Creates and initialises the local mutable array, shoes
  2. Converts the databasePath from an NSString into a pure string for use with the database
  3. IF opening the database is successful
    a. Creates the SQL as a constant char
    b. Declares an SQLite3 statement
    c. Executes the statement, IF it executes successfully
        i. While there are rows to read
           ii. Retrieves the shoeID as an integer from the first column in the database
          iii. Retrieves the shoe name as a char from the second column in the database
           iv. Retrieves the shoe distance as a double from the third column in the database
            v. Retrieves the shoe image name as a char from the fourth column in the database
           vi. Creates and initialises the shoe object
          vii. Adds the new shoe to the array shoes
    d. Releases the statement
    e. Closes the database
 4. ELSE logs "Error Opening Database"
 5. Returns the shoes array
 */
-(NSArray *)loadAllShoes {
    NSMutableArray *shoes = [[NSMutableArray alloc] init]; //1
    
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        const char *sqlChar = "SELECT * FROM tblShoes"; //a
        sqlite3_stmt *statement; //b
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) { //c
            while (sqlite3_step(statement) == SQLITE_ROW) { //i
                int shoeID = (int)sqlite3_column_int(statement, 0); //ii
                char *shoeName = (char *)sqlite3_column_text(statement, 1); //iii
                double currentDistance = (double)sqlite3_column_double(statement, 2); //iv
                char *shoeImageName = (char *)sqlite3_column_text(statement, 3); //v
                
                Shoe *shoe = [[Shoe alloc] initWithID:shoeID name:[NSString stringWithUTF8String:shoeName] miles:currentDistance imageName:[NSString stringWithUTF8String:shoeImageName]]; //vi
                
                [shoes addObject:shoe]; //vii
            }
        }
        
        sqlite3_finalize(statement); //d
        sqlite3_close(_database); //e
    } else { //4
        NSLog(@"Error Opening Database");
    }
    
    return shoes; //5
}

/**
 1. Creates and initialises the local Shoe object variable, shoe
 2. Converts the databasePath from an NSString into a pure string for use with the database
 3. IF opening the database is successful
    a. Creates the SQL as an NSString
    b. Converts the SQL to a constant char
    c. Declares an SQLite3 statement
    d. Executes the statement, IF it executes successfully
        i. While there are rows to read
           ii. Retrieves the shoeID as an integer from the first column in the database
          iii. Retrieves the shoe name as a char from the second column in the database
           iv. Retrieves the shoe distance as a double from the third column in the database
            v. Retrieves the shoe image name as a char from the fourth column in the database
           vi. Creates and initialises the shoe object
    e. Releases the statement
    f. Closes the database
 4. ELSE logs "Error Opening Database"
 5. Returns the shoes array
 */
-(Shoe *)loadShoeWithID:(int)ID {
    Shoe *shoe; //1
    
    const char *charDbPath = [_databasePath UTF8String]; //2
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //3
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblShoes WHERE ShoeID = '%i'", ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        sqlite3_stmt *statement; //c
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) { //d
            while (sqlite3_step(statement) == SQLITE_ROW) { //i
                int shoeID = (int)sqlite3_column_int(statement, 0); //ii
                char *shoeName = (char *)sqlite3_column_text(statement, 1); //iii
                double currentDistance = (double)sqlite3_column_double(statement, 2); //iv
                char *shoeImageName = (char *)sqlite3_column_text(statement, 3); //v
                
                shoe = [[Shoe alloc] initWithID:shoeID name:[NSString stringWithUTF8String:shoeName] miles:currentDistance imageName:[NSString stringWithUTF8String:shoeImageName]]; //vi
            }
        }
        
        sqlite3_finalize(statement); //e
        sqlite3_close(_database); //f
    } else { //4
        NSLog(@"Error Opening Database");
    }
    
    return shoe; //5
    
}

 /**
  1. Declares the local boolean variable shoeNameExists and sets it to NO (false)
  2. Converts the databasePath from an NSString into a pure string for use with the database
  3. IF opening the database is successful
    a. Creates the SQL as an NSString
    b. Converts the SQL to a constant char
    c. Declares an SQLite3 statement
    d. IF the SQL executes successfully
        i. IF there is a row returned
            ii. Sets shoeNameExists to YES (true)
    e. ELSE logs "Error checking if shoe exists"
    f. Releases the statement
    g. Closes the database
  4. Else logs "Error Opening Database"
  5. Returns shoeNameExists
 */
-(BOOL)shoeNameExists:(NSString *)shoeName {
    BOOL shoeNameExists = NO;
    
    const char *charDbPath = [_databasePath UTF8String];
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblShoes WHERE ShoeName = '%@'", shoeName];
        const char *sqlChar = [sql UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(_database, sqlChar, -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                shoeNameExists = YES;
            }
        } else {
            NSLog(@"Error Checking If Shoe Exists");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    } else {
        NSLog(@"Error Opening Database");
    }
    
    return shoeNameExists;
}

#pragma mark Shoe Deleting

 /**
  1. Converts the databasePath from an NSString into a pure string for use with the database
  2. IF opening the database is successful
    a. Creates the SQL
    b. Converts the SQL into a pure string to use with the database
    c. Declares the local char variable errorMessage
    d. IF the SQL does not execute successfully
        i. Convert the error message into an NSString
       ii. Log "Error deleting shoe: " and the error message
      iii. Closes the database
       iv. Returns NO (false)
    e. ELSE
        i. Logs "Shoe Deleted Successfully"
       ii. Closes the database
      iii. Returns YES (true)
 3. ELSE logs "Error Opening Database"
 4. Returns NO (false)
 */
-(BOOL)deleteShoe:(Shoe *)shoe {
    const char *charDbPath = [_databasePath UTF8String]; //1
    
    if (sqlite3_open(charDbPath, &_database) == SQLITE_OK) { //2
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM tblShoes WHERE ShoeID = '%li'", (long)shoe.ID]; //a
        const char *sqlChar = [sql UTF8String]; //b
        char *errorMessage; //c
        
        if (sqlite3_exec(_database, sqlChar, nil, nil, &errorMessage) != SQLITE_OK) { //d
            NSString *error = [NSString stringWithUTF8String:errorMessage]; //i
            NSLog([NSString stringWithFormat:@"Error deleting shoe: %@", error]); //ii
            sqlite3_close(_database); //iii
            return  NO; //iv
        } else { //e
            NSLog(@"Shoe Deleted Successfully"); //i
            sqlite3_close(_database); //ii
            return [self removeShoeFromRuns:shoe]; //iii
        }
    } else { //3
        NSLog(@"Error Opening Database");
    }
    
    return NO; //4
}


@end
