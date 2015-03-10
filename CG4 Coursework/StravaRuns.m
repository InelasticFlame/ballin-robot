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

@interface StravaRuns ()

@property NSInteger runsLoaded;

@end

@implementation StravaRuns

-(void)loadRunsFromStrava {
    _runsLoaded = 0;
    
    NSMutableArray *runs = [[NSMutableArray alloc] init];
    NSDate *lastLoadDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-604800];
    
    NSString *lastLoad = [[NSUserDefaults standardUserDefaults] stringForKey:@"LAST_LOAD"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date].shortDateString forKey:@"LAST_LOAD"];
    
    if (lastLoad != nil) {
        lastLoadDate = [[NSDate alloc] initWithTimeInterval:86400 sinceDate: [[NSDate alloc] initWithShortDateString:lastLoad]];
    }
    
    
    [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentAthleteAfterDate:lastLoadDate success:^(NSArray *activities) {
        for (StravaActivity *activity in activities) {
            Conversions *converter = [[Conversions alloc] init];
            double distance = [converter metresToMiles:activity.distance];
            NSDate *dateTime = activity.startDate;
            NSInteger pace = [converter metresPerSecondToSecondsPerMile:activity.averageSpeed];
            NSInteger duration = activity.movingTime;
            
            NSMutableArray *CLCoords = [[NSMutableArray alloc] init];
            NSArray *polylinePoints = [StravaMap decodePolyline:activity.map.summaryPolyline];
            for (NSValue *coord in polylinePoints) {
                CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:[coord MKCoordinateValue].latitude longitude:[coord MKCoordinateValue].longitude];
                [CLCoords addObject:coordinate];
            }
            
            Run *run = [[Run alloc] initWithRunID:activity.id distance:distance dateTime:dateTime pace:pace duration:duration shoe:nil runScore:0 runLocations:CLCoords runType:@"run" splits:nil];
            [run calculateRunScore];
            
            if ([run valid] == YES) {
                [runs addObject:run];
            }
        }
        
        for (Run *run in runs) {
            [[FRDStravaClient sharedInstance] fetchLapsForActivity:run.ID success:^(NSArray *laps){
                for (StravaActivityLap *lap in laps) {
                    NSInteger lapPace = [[[Conversions alloc] init] metresPerSecondToSecondsPerMile:lap.averageSpeed];
                    [run addSplit:lapPace];
                }
                [[Database init] saveRun:run];
                _runsLoaded ++;
                
                if (_runsLoaded == activities.count) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RunLoadComplete" object:nil];
                }
            }failure:^(NSError *error){
                NSLog([NSString stringWithFormat:@"%@", error.localizedDescription]);
            }];
        }
        if (activities.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RunLoadComplete" object:nil];
        }
        
    } failure:^(NSError *error) {
        NSLog([NSString stringWithFormat:@"%@", error.localizedDescription]);
    }];
}

@end
