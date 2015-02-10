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
            static let UnitKey = "CALORIE_UNIT"
        }
        
        struct MapStyle {
            static let StyleKey = "MAP_STYLE"
            static let Hybrid = "HYBRID"
            static let Satellite = "SATELLITE"
            static let Standard = "STANDARD"
        }
    }
    
    struct SQLQuerys {

    }
    
    struct PickerView {
        
        struct Type {
            static let Distance = "DISTANCE_PICKER"
            static let Pace = "PACE_PICKER"
            static let Shoe = "SHOE_PICKER"
            static let Duration = "DURATION_PICKER"
            static let RunType = "RUN_TYPE_PICKER"
        }
        
        struct Attributes {
            
            struct Distance {
                static let NumberOfRows = [100, 100, 2]
                static let NumberOfComponents = 3
                static let Format = ["%i", ".%02i", "%@"]
                static let Content = [["row"], ["row"], ["mi", "km"]]
            }
            
            struct Pace {
                static let NumberOfRows = [60, 60, 2]
                static let NumberOfComponents = 3
                static let Format = ["%im", "%02is", "%@"]
                static let Content = [["row"], ["row"], ["/mi", "/km"]]
            }
            
            struct Duration {
                static let NumberOfRows = [24, 60, 60]
                static let NumberOfComponents = 3
                static let Format = ["%ih", "%02im", "%02is"]
                static let Content = [["row"], ["row"], ["row"]]
            }
            
            struct RunType {
                static let NumberOfRows = [4]
                static let NumberOfComponents = 1
                static let Format = ["%@"]
                static let Content = [["Run", "Jog", "Road", "Trail"]]
            }
            
            struct Shoe {
                static let NumberOfRows = [0]
                static let NumberOfComponents = 1
                static let Format = ["%@"]
                static let Content = [["DB_LOOKUP"]]
            }
        }
    }
}
