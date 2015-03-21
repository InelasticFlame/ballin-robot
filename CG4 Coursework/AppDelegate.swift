//
//  AppDelegate.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /**
    This method is called by the system when the app is opened via a URL (set in the Info.plist file)
    1. Calls the function checkReturnURL passing the url that opened the app
    */
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        StravaAuth().checkReturnURL(url) //1
        
        return true
    }
}

