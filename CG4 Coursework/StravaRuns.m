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

-(void)loadRunsFromStrava {
    NSMutableArray *runs = [[NSMutableArray alloc] init];
    [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentAthleteWithPageSize:30 pageIndex:1 success:^(NSArray *activities) {
        for (StravaActivity *activity in activities) {
            Conversions *converter = [[Conversions alloc] init];
            double distance = [converter metresToMiles:activity.distance];
            NSDate *dateTime = activity.startDate;
            NSInteger pace = [converter metresPerSecondToMinPerMile:activity.averageSpeed];
            NSInteger duration = activity.movingTime;
            
            NSMutableArray *CLCoords = [[NSMutableArray alloc] init];
            NSArray *polylinePoints = [StravaMap decodePolyline:activity.map.summaryPolyline];
            for (NSValue *coord in polylinePoints) {
                CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:[coord MKCoordinateValue].latitude longitude:[coord MKCoordinateValue].longitude];
                [CLCoords addObject:coordinate];
            }
            
            Run *run = [[Run alloc] initWithRunID:activity.id distance:distance dateTime:dateTime pace:pace duration:duration shoe:nil runScore:0 runLocations:CLCoords runType:@"run" splits:nil];
            [run calculateRunScore];
            
            [runs addObject:run];
        }
        
        for (Run *run in runs) {
            [[FRDStravaClient sharedInstance] fetchLapsForActivity:run.ID success:^(NSArray *laps){
                for (StravaActivityLap *lap in laps) {
                    NSInteger lapPace = [[[Conversions alloc] init] metresPerSecondToMinPerMile:lap.averageSpeed];
                    [run addSplit:lapPace];
                }
                [[Database init] saveRun:run];
            }failure:^(NSError *error){
                NSLog([NSString stringWithFormat:@"%@", error.localizedDescription]);
            }];
        }
        
        
    } failure:^(NSError *error) {
        NSLog([NSString stringWithFormat:@"%@", error.localizedDescription]);
    }];
}
@end
