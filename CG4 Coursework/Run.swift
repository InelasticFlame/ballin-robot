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
    */
    func calculateRunScore() {
        
        let pointsFromPaceMultiplier = 1000.0/Float(self.pace)
        let pointsFromAveragePace = Double(pow(2.4, pointsFromPaceMultiplier) * 120)

        let pointsFromDistanceMultiplier = 1000.0/Float(self.distance)
        let pointsFromDistance = Double(pow(2.2, pointsFromPaceMultiplier)) * 75
        
        let totalPoints = (pointsFromDistance + pointsFromAveragePace)
        
        self.score = totalPoints
    }
    
    func addSplit(split: Int) {
        self.splits.append(split)
    }
    
    func scoreColour() -> UIColor {
        if self.score < 300 {
            return UIColor.redColor()
        } else if self.score < 700 {
            return UIColor.orangeColor()
        } else {
            return UIColor.greenColor()
        }
    }
    
    func calculateRunFinishTimes() -> (fiveK : String, tenK: String, halfMarathon: String, fullMarathon: String) {
        let fiveK = Int(Double(self.pace) * 3.1)
        let tenK = Int(Double(self.pace) * 6.2)
        let halfMarathon = Int(Double(self.pace) * 13.1)
        let fullMarathon = Int(Double(self.pace) * 26.2)
        
        let fiveKStr = "5k: " + Conversions().runDurationForInterface(fiveK)
        let tenKStr = "10k: " + Conversions().runDurationForInterface(tenK)
        let halfMarathonStr = "Half: " + Conversions().runDurationForInterface(halfMarathon)
        let fullMarathonStr = "Full: " + Conversions().runDurationForInterface(fullMarathon)
        
        return (fiveKStr, tenKStr, halfMarathonStr, fullMarathonStr)
    }

    func valid() -> Bool {
        if self.distance > 0 && self.duration > 0 && self.pace > 0 {
            return true
        } else {
            return false
        }
    }

}