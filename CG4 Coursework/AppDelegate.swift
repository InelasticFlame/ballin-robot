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
    
    :param: application The App itself.
    :param: url The URL the app was opened with.
    :returns: Returns a boolean value indicating if the delegate successfully handle the URL request.
    */
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        StravaAuth().checkReturn(url as URL) //1
        
        return true
    }
}

