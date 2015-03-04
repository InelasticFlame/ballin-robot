//
//  GlobalConstants.swift
//  CG4 Coursework
//
//  Created by William Ray on 01/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

struct Constants {
    
    struct DefaultsKeys {
        
        struct InitialSetup {
            static let SetupKey = "INITIAL_SETUP"
        }
        
        struct Distance {
            static let UnitKey = "DISTANCE_UNIT"
            static let GoalKey = "GOAL_DISTANCE"
        }
        
        struct Pace {
            static let UnitKey = "PACE_UNIT"
        }
        
        struct Weight {
            static let UnitKey = "WEIGHT_UNIT"
            static let GoalKey = "WEIGHT_GOAL"
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
    }
}
