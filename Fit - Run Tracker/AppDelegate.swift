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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if ProcessInfo.processInfo.arguments.contains("UITests") {
            setStateForUITesting()
        }

        return true
    }

    private func setStateForUITesting() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(Constants.DefaultsKeys.Distance.MilesUnit, forKey: Constants.DefaultsKeys.Distance.UnitKey)
        userDefaults.set(500, forKey: Constants.DefaultsKeys.Distance.GoalKey)
        userDefaults.set(Constants.DefaultsKeys.Pace.MinMileUnit, forKey: Constants.DefaultsKeys.Pace.UnitKey)
        userDefaults.set(Constants.DefaultsKeys.Weight.KgUnit, forKey: Constants.DefaultsKeys.Weight.UnitKey)
        userDefaults.set(65.0, forKey: Constants.DefaultsKeys.Weight.GoalKey)
        userDefaults.set(2000, forKey: Constants.DefaultsKeys.Calories.GoalKey)
        userDefaults.set(true, forKey: Constants.DefaultsKeys.InitialSetup.SetupKey)
    }

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
