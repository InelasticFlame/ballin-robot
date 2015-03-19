//
//  Run.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Run: NSObject {
    
    //MARK: - Properties
    
    var ID: Int
    var distance: Double
    var dateTime: NSDate
    var pace: Int
    var duration: Int
    var shoe: Shoe?
    var score: Double
    var locations = Array<CLLocation>()
    var type: String
    var splits = Array<Int>()
    
    //MARK: - Initialisation
    
    override init() { //Creates a new run object with default values
        self.ID = 0
        self.distance = 0
        self.dateTime = NSDate()
        self.pace = 0
        self.duration = 0
        self.score = 0
        self.type = ""
    }
    
    /**
    Called to initialise the class, sets the properties of the Shoe to the passed values.
    */
    init(runID: Int, distance: Double, dateTime: NSDate, pace: Int, duration: Int, shoe: Shoe?, runScore: Double, runLocations: Array<CLLocation>?, runType: String, splits: Array<Int>?) {
        self.ID = runID
        self.distance = distance
        self.dateTime = dateTime
        self.pace = pace
        self.duration = duration
        self.shoe = shoe
        self.score = runScore
        self.type = runType
        if let _locations = runLocations { //if there are locations, store them
            self.locations = _locations
        }
        if let _splits = splits { //if there are splits, store them
            self.splits = _splits
        }
    }
    
    /**
    This method calculates the score for a run in the following way:
    1.
    2.
    3.
    4.
    5.
    6.
    */
    func calculateRunScore() {
        let pointsFromPacePower = 1000.0/Float(self.pace) //1
        let pointsFromAveragePace = Double(pow(2.4, pointsFromPacePower) * 120) //2
        
        let pointsFromDistancePower = Float(self.distance)/10 //3
        let pointsFromDistance = Double(pow(2.4, pointsFromDistancePower)) * 120 //4
        
        let totalPoints = (pointsFromDistance + pointsFromAveragePace) //5
        
        if totalPoints > 1000 {
            self.score = 1000
        } else {
            self.score = totalPoints //6
        }
    }
    
    /**
    This method adds a split to the array of stored splits for the run. This method is necassary as runs are created in an Objective-C environment (where arrays are just arrays of objects). In this case the split would have to be converted to an NSNumber object and then added to the array, so it is easy to pass the integer value for the split to the class and add it to the array in Swift.
    */
    func addSplit(split: Int) {
        self.splits.append(split)
    }
    
    /**
    This method returns the appropriate colour for the run's score.
    1. IF the score is less than 400
        a. Return the redColour
    2. IF the scores is less than 700
        b. Return the orangeColour
    3. ELSE
        c. Return the greenColour
    */
    func scoreColour() -> UIColor {
        if self.score < 400 { //1
            return UIColor.redColor() //a
        } else if self.score < 700 { //2
            return UIColor.orangeColor() //b
        } else { //3
            return UIColor.greenColor() //c
        }
    }
    
    func calculateRunFinishTimes() -> (fiveK : String, tenK: String, halfMarathon: String, fullMarathon: String) {
        let fiveK = Int(Double(self.pace) * 3.1)
        let tenK = Int(Double(self.pace) * 6.2)
        let halfMarathon = Int(Double(self.pace) * 13.1)
        let fullMarathon = Int(Double(self.pace) * 26.2)
        
        let fiveKStr = Conversions().runDurationForInterface(fiveK)
        let tenKStr = Conversions().runDurationForInterface(tenK)
        let halfMarathonStr = Conversions().runDurationForInterface(halfMarathon)
        let fullMarathonStr = Conversions().runDurationForInterface(fullMarathon)
        
        return (fiveKStr, tenKStr, halfMarathonStr, fullMarathonStr)
    }

    /**
    This method determines whether a created run object is valid. It returns a boolean value based on the result of the test.
    1. IF the distance, duration and pace are all greater than nothing (this is to handle the case where a run returned from Strava has erroneous values e.g. -1)
        a. Return true
    2. ELSE return false
    */
    func valid() -> Bool {
        if self.distance > 0 && self.duration > 0 && self.pace > 0 {
            return true
        } else {
            return false
        }
    }
    
    /**
    This method prints a descrption of the run object for use in testing.
    */
    func description() -> String {
        let string = "ID = '\(self.ID)', DateTime = '\(self.dateTime.description)', Pace = '\(self.pace)', Duration = '\(self.duration)', Score = '\(self.score)', Number of locations = '\(self.locations.count)', Number of splits = '\(self.splits.count)'"
        
        return string
    }
}