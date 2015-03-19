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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.x
        
        /*
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8 {
            UITableView.appearance().layoutMargins = UIEdgeInsetsZero
            UITableViewCell.appearance().layoutMargins = UIEdgeInsetsZero
            UITableViewCell.appearance().preservesSuperviewLayoutMargins = false
        }
        */
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        println(url)
        
        StravaAuth().checkReturnURL(url)
        
        return true
    }
}

