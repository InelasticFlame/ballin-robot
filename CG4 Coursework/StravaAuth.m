//
//  StravaAuth.m
//  CG4 Coursework
//
//  Created by William Ray on 23/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

#import "StravaAuth.h"
#import "FRDStravaClientImports.h"

#pragma GCC diagnostic ignored "-Wformat-security"

@implementation StravaAuth

-(id)init {
    
    if (self = [super init]) {
        NSInteger clientID = 2994;
        NSString *clientSecret = @"6b17bcebb30c4292e11965f0629e5add52d2486b";
        
        [[FRDStravaClient sharedInstance] initializeWithClientId:clientID clientSecret:clientSecret];
    }
    
    return self;
}

-(void)authorise {
    NSString *previousAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ACCESS_TOKEN"];
    
    if ([previousAccessToken length] > 0) {
        [[FRDStravaClient sharedInstance] setAccessToken:previousAccessToken];
        
    } else {
        NSString *url = @"CG4Coursework://authorization";
        
        [[FRDStravaClient sharedInstance] authorizeWithCallbackURL:[NSURL URLWithString:url] stateInfo:nil];
    }
}

-(void)checkReturnURL:(NSURL *)url {
    [[FRDStravaClient sharedInstance] parseStravaAuthCallback:url withSuccess:^(NSString *stateInfo, NSString *code){
        
        [[FRDStravaClient sharedInstance] exchangeTokenForCode:code success:^(StravaAccessTokenResponse *response){
            [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:@"ACCESS_TOKEN"];
            
        }failure:^(NSError *error) {
            NSLog([NSString stringWithFormat:@"%@", error.localizedDescription]);
        }];
        
    } failure:^(NSString *stateInfo, NSString *error) {
        NSLog([NSString stringWithFormat:@"%@", error]);
    }];
}

@end
