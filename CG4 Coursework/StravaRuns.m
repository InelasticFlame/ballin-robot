//
//  StravaRuns.m
//  CG4 Coursework
//
//  Created by William Ray on 23/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

#import "StravaRuns.h"
#import "Database.h"
#import "FRDStravaClientImports.h"
#import <CG4_Coursework-Swift.h>
#import <MapKit/MapKit.h>

#pragma GCC diagnostic ignored "-Wformat-security"

@implementation StravaRuns

NSInteger runsLoaded; //A global NSInteger variable that tracks the number of runs loaded

/**
This method is used to retrieve a user's runs from their Strava account. In the first case it loads runs from the previous week, after which it loads runs from the current date to the last date loaded.
 1. Sets the value of runsLoaded to 0
 2. Declares and initialises an NSMutableArray, runs
 3. Sets the last load date to be an NSDate 1 week ago
 4. Retrieves the last load from the NSUserDefaults as a date string
 5. IF the lastLoad is not nil (i.e. runs have been loaded before)
    a. Set the lastLoadDate to be the end of the day (86400 seconds) of the NSDate created using the lastLoad short date string
 6. Call the function fetchActivitiesForCurrentAthleteAfterDate using the sharedInstance of the FRDStravaClient passing the lastLoadDate
 7. On success perform the BLOCK A
 ****BLOCK A****
 1. Set the object for the key "LAST_LOAD" in the NSUserDefaults as the short date string of the current date
 2. FOR each activity in the array of activities
    a. Create an instance of the Conversions class
    b. Set the distance as a double using the metresToMiles function from the converter passing the activity distance
    c. Set the date time of the run as the activity start date
    d. Set the pace of the run as an NSInteger using the metresPerSecondToSecondsPerMile function from the converter passing the activity average speed
    e. Set the duration of the run as the activity moving time
    f. Create and initialise an NSMutableArray CLCoords
    g. Create the NSArray polylinePoints by decoding the polyline of the activity
    h. FOR each coord (as an NSValue) in the array polylinePoints
        i. Create the CLLocation object using the MKCoordinateValue of the coord
       ii. Add the CLLocation to the array CLCoords
    i. Create the run (using the activity ID for the time being)
    j. Calculate the run score
    k. IF the run is valid add the run to the array runs
 3. FOR each run in the array runs
    l. Call the function fetchLapsForActivity using the shared instance of the FRDStravaClient passing the run.ID
    m. On success perform the BLOCK B
 ****BLOCK B****
 1. FOR each lap in the array of laps
    a. IF the lap has a distance of 1609.35 (1 mile in metres)
        i. Add the lap moving time as a run split
    b. Save the run using the saveRun function from the Database class
    c. Increase the value of runsLoaded by 1
    d. IF runsLoaded is the number of runs in the array
       ii. Post the notification "RunLoadComplete"
 ****END   B****
 4. IF there are no activities post the notification "RunLoadComplete"
 ****END   A****
 For both BLOCK A failure and BLOCK B failure log the localised description of the error
 */
-(void)loadRunsFromStrava {
    runsLoaded = 0; //1
    
    NSMutableArray *runs = [[NSMutableArray alloc] init]; //2
    NSDate *lastLoadDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-604800]; //3
    
    NSString *lastLoad = [[NSUserDefaults standardUserDefaults] stringForKey:@"LAST_LOAD"]; //4
    
    if (lastLoad != nil) { //5
        lastLoadDate = [[NSDate alloc] initWithTimeInterval:86400 sinceDate: [[NSDate alloc] initWithShortDateString:lastLoad]]; //a
    }
    
    
    [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentAthleteAfterDate:lastLoadDate success:^(NSArray *activities) { //6
        /* BLOCK A START */ //7
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date].shortDateString forKey:@"LAST_LOAD"]; //1
        
        for (StravaActivity *activity in activities) { //2
            Conversions *converter = [[Conversions alloc] init]; //a
            double distance = [converter metresToMiles:activity.distance]; //b
            NSDate *dateTime = activity.startDate; //c
            NSInteger pace = [converter metresPerSecondToSecondsPerMile:activity.averageSpeed]; //d
            NSInteger duration = activity.movingTime; //e
            
            NSMutableArray *CLCoords = [[NSMutableArray alloc] init]; //f
            NSArray *polylinePoints = [StravaMap decodePolyline:activity.map.summaryPolyline]; //g
            
            
            for (NSValue *coord in polylinePoints) { //h
                CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:[coord MKCoordinateValue].latitude longitude:[coord MKCoordinateValue].longitude]; //i
                [CLCoords addObject:coordinate]; //ii
            }
            
            Run *run = [[Run alloc] initWithRunID:activity.id distance:distance dateTime:dateTime pace:pace duration:duration shoe:nil runScore:0 runLocations:CLCoords splits:nil]; //i
            [run calculateRunScore]; //j
            
            if ([run valid] == YES) { //k
                [runs addObject:run];
            }
        }
        
        for (Run *run in runs) { //3
            [[FRDStravaClient sharedInstance] fetchLapsForActivity:run.ID success:^(NSArray *laps){ //l
                /* BLOCK B START */ //m
                for (StravaActivityLap *lap in laps) { //1
                    if (lap.distance == 1609.35) { //a
                        [run addSplit:lap.movingTime]; //i
                    }
                }
                [[Database init] saveRun:run]; //b
                runsLoaded ++; //c
                
                if (runsLoaded == runs.count) { //d
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RunLoadComplete" object:nil]; //ii
                }
                /* BLOCK B START */
            }failure:^(NSError *error){
                /* BLOCK B FAILURE START */
                NSLog([NSString stringWithFormat:@"%@", error.localizedDescription]);
                /* BLOCK B FAILURE END */
            }];
        }
        if (activities.count == 0) { //4
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RunLoadComplete" object:nil];
        }
       /* BLOCK A END */
    } failure:^(NSError *error) {
        /* BLOCK A FAILURE START */
        NSLog([NSString stringWithFormat:@"%@", error.localizedDescription]);
        /* BLOCK A FAILURE END */
    }];
}

@end
