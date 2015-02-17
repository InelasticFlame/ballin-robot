//
//  Database.h
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>

@interface Database : NSObject {
    sqlite3 *_database; //Local instance variable
}

@property NSString *databasePath; //Property that stores the path to the database

/* Declare the public functions */
+(Database*)init;

//Runs
-(void)saveRun:(NSObject *)Run;
-(NSArray *)loadRunsWithQuery:(NSString *)query;
-(BOOL)deleteRunWithID:(NSObject *)run;

//Plans
-(NSObject *)createNewPlanWithName:(NSString*)name startDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;
-(NSArray *)loadAllTrainingPlans;

//Shoes
-(void)saveShoe;

@end
