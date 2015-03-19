//
//  GlobalConstants.swift
//  CG4 Coursework
//
//  Created by William Ray on 01/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

struct Constants {
    /* This class stores constants that should be accessible to all classes within the app. */
    
    struct DefaultsKeys { //User Defaults Keys and return values
        
        struct InitialSetup {
            static let SetupKey = "INITIAL_SETUP"
        }
        
        struct Distance {
            static let UnitKey = "DISTANCE_UNIT"
            static let GoalKey = "GOAL_DISTANCE"
            static let MilesUnit = "MILES"
            static let KmUnit = "KILOMETRES"
        }
        
        struct Pace {
            static let UnitKey = "PACE_UNIT"
            static let MinMileUnit = "MIN/MILE"
            static let KMPerH = "KM/H"
        }
        
        struct Weight {
            static let UnitKey = "WEIGHT_UNIT"
            static let GoalKey = "WEIGHT_GOAL"
            static let KgUnit = "KG"
            static let PoundUnit = "POUNDS"
        }
        
        struct Calories {
            static let GoalKey = "CALORIE_UNIT"
        }
        
        struct MapStyle {
            static let StyleKey = "MAP_STYLE"
            static let Hybrid = "HYBRID"
            static let Satellite = "SATELLITE"
            static let Standard = "STANDARD"
        }
        
        struct PersonalBests {
            static let LongestDistanceKey = "LONGEST_DISTANCE"
            static let LongestDurationKey = "LONGEST_DURATION"
            static let FastestAvgPaceKey = "FASTEST_AVERAGE_PACE"
            static let FastestMileKey = "FASTEST_MILE"
        }
        
        struct Strava {
            static let AccessTokenKey = "ACCESS_TOKEN"
        }
    }
    
    struct TableView {
        static let PickerRowHeight: CGFloat = 162 //A global constant GCFloat that stores the height of a cell that contains a picker view
        static let DefaultRowHeight: CGFloat = 44 //A global constant CGFloat that stores the default height for a cell
        static let ImageRowHeight: CGFloat = 250 //A global constant CGFloat that stores the height for the image cell
    }
}

/* Expose Personal Best Keys to Obj-C */
@objc class ObjConstants {
    private init() {}
    
    class func longestDistanceKey() -> String { return Constants.DefaultsKeys.PersonalBests.LongestDistanceKey }
    class func longestDurationKey() -> String { return Constants.DefaultsKeys.PersonalBests.LongestDurationKey }
    class func fastestMileKey() -> String { return Constants.DefaultsKeys.PersonalBests.FastestMileKey }
    class func fastestAvgPaceKey() -> String { return Constants.DefaultsKeys.PersonalBests.FastestAvgPaceKey }
}
