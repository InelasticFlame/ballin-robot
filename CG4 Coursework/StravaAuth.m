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

#pragma mark - Initialisation

 /**
  1. Initialises the class; if successful
    a. Declares the local integer variable clientID of value 2994 (this is fixed to the value of set by the Strava API application online)
    b. Declares the local string variable clientSecret (this value is fixed to the value set by the Strava API applicatiion online)
    c. Initialises the StravaClient with the clientID and clientSecret
  2. Returns the class
 */
-(id)init {
    
    if (self = [super init]) { //1
        NSInteger clientID = 2994; //a
        NSString *clientSecret = @"6b17bcebb30c4292e11965f0629e5add52d2486b"; //b
        
        [[FRDStravaClient sharedInstance] initializeWithClientId:clientID clientSecret:clientSecret]; //b
    }
    
    return self; //2
}

#pragma mark - Authorisation

 /**
  This method is called to authorise a new account; in this case there will be no access token already set, or if there is already an access token it is to be ignored so a new account can be linked.
  1. Declares the local string variable url; this is the url that the authorisation request will return using (this is configured online using the Strava API application)
  2. Calls the function authorizeWithCallbackURL from the currently initialised StravaClient
 */
-(void)authoriseNewAccount {
    NSString *url = @"CG4Coursework://authorization"; //1
    
    [[FRDStravaClient sharedInstance] authorizeWithCallbackURL:[NSURL URLWithString:url] stateInfo:nil]; //2
}

 /**
  This method is called to authorise the user; if there is already an access token stored it uses that otherwise it prompts a user to connect their Strava account
  1. Declares and intialises the local variable previousAccessToken which is the stored string for the key "ACCESS_TOKEN"
  2. IF the previousAccessToken has a length greater than 0
    a. Sets the access token of the StravaClient to the previousAccessToken
    b. Posts the notification "AuthorisedSuccessfully" to alert any classes that are listening that authorisation has completed
  3. ELSE
    a. Declares the local string variable url; this is the url that the authorisation request will return using (this is configured online using the Strava API application)
    b. Calls the function authorizeWithCallbackURL from the currently initialised StravaClient
 */
-(void)authorise {
    NSString *previousAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ACCESS_TOKEN"];
    
    if ([previousAccessToken length] > 0) {
        [[FRDStravaClient sharedInstance] setAccessToken:previousAccessToken];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthorisedSuccessfully" object:nil];
        
    } else {
        NSString *url = @"CG4Coursework://authorization";
        
        [[FRDStravaClient sharedInstance] authorizeWithCallbackURL:[NSURL URLWithString:url] stateInfo:nil];
    }
}

#pragma mark - URL Return

 /**
  This method is called when the application is opened from a URL. It parses the returned URL to retrieve the user's access token.
  1. Calls the function parseStravaAuthCallBack using the current instance of the StravaClient passing the url
  On completion performs the block
    Success Block
        B1a. Calls the function exchangeTokenForCode passing the code returned from the block
        On completion performs the block
        Success
            B2a. Saves the accessToken to the local user defaults
            B2b. Posts the notification "AuthorisedSuccessfully" to alert any classes that are listening that authorisation has completed
        Failure
            B2c. Logs "Error retrieving access token" and the localised error description
    Failure block
        B1b. Logs "Error parsing access token" and the localised error description
 */
-(void)checkReturnURL:(NSURL *)url {
    [[FRDStravaClient sharedInstance] parseStravaAuthCallback:url withSuccess:^(NSString *stateInfo, NSString *code){ //1
        /* SUCCESS 1 BLOCK START */
        
        NSLog([NSString stringWithFormat:@"%@", url]);
        
        [[FRDStravaClient sharedInstance] exchangeTokenForCode:code success:^(StravaAccessTokenResponse *response){ //B1a
            /* SUCCESS 2 BLOCK START */
            [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:@"ACCESS_TOKEN"]; //B2a
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthorisedSuccessfully" object:nil]; //B2b
            /* SUCCESS 2 BLOCK END */
        }failure:^(NSError *error) {
            /* FAILURE 2 BLOCK START */
            NSLog([NSString stringWithFormat:@"Error retrieving access token: %@", error.localizedDescription]); //B2c
            /* FAILURE 2 BLOCK END */
        }];
        /* SUCCESS 1 BLOCK END */
    } failure:^(NSString *stateInfo, NSString *error) {
        /* FAILURE 1 BLOCK START */
        NSLog([NSString stringWithFormat:@"Error parsing access token: %@", error]); //B1b
        /* FAILURE 1 BLOCK START */
    }];
}

@end
