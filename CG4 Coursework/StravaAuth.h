//
//  StravaAuth.h
//  CG4 Coursework
//
//  Created by William Ray on 23/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StravaAuth : NSObject

-(void)checkReturnURL:(NSURL *)url;
-(void)authorise;
-(void)authoriseNewAccount;

@end
