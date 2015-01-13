//
//  Run.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Run: NSObject {
    
    let consecutiveRunMultiplier = 0.1
    let numberOfConsecutiveRuns = 0.0
    
    var ID: Int
    var distance: Double
    var dateTime: NSDate
    var pace: Int
    var duration: Int
    var shoe: Shoe?
    var score: Double
    var locations: Array<CLLocation>?
    var type: String
    var splits: Array<Int>?
    
    init(runID: Int, distance: Double, dateTime: NSDate, pace: Int, duration: Int, shoe: Shoe?, runScore: Double, runLocations: Array<CLLocation>?, runType: String, splits: Array<Int>?) {
        self.ID = runID
        self.distance = distance
        self.dateTime = dateTime
        self.pace = pace
        self.duration = duration
        self.shoe = shoe
        self.score = runScore
        self.locations = runLocations
        self.type = runType
        self.splits = splits
    }
    
    func calculateRunScore() {
        let pointsFromPaceMultiplier = 1000.0/Float(self.pace)
        let pointsFromAveragePace = Double(pow(2.4, pointsFromPaceMultiplier) * 120)
        
        let pointsFromDistanceMultiplier = 1000.0/Float(self.distance)
        let pointsFromDistance = Double(pow(2.2, pointsFromPaceMultiplier)) * 75
        
        let consecutiveDayMultiplier = (consecutiveRunMultiplier * numberOfConsecutiveRuns) + 1
        let totalPoints = (pointsFromDistance + pointsFromAveragePace) * consecutiveDayMultiplier
        
        self.score = totalPoints
    }
    
    func addSplit(split: Int) {
        if let splits = splits {
            self.splits!.append(split)
        } else {
            self.splits = [split]
        }
    }
}