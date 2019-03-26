//
//  Run.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Run: NSObject {

    // MARK: - Properties

    var ID: Int //A property that stores the ID of a run
    var distance: Double //The distance of the run, stored in miles
    var dateTime: NSDate //The date an time at which the run was ran
    var pace: Int //The pace of the run, stored in secs per mile
    var duration: Int //The duration of the run, stored in seconds
    var shoe: Shoe? //The shoe for the run, if there is one
    var score: Double //The score of the run, with the maximum being 1000
    var locations = Array<CLLocation>() //The locations for the run, used to draw the run route
    var splits = Array<Int>() //The mile splits for the run, stored in seconds for each mile

    // MARK: - Initialisation

    override init() { //Creates a new run object with default values
        self.ID = 0
        self.distance = 0
        self.dateTime = NSDate()
        self.pace = 0
        self.duration = 0
        self.score = 0
    }

    /**
    Called to initialise the class, sets the properties of the Run to the passed values.
    
    :param: runID The ID of the run.
    :param: distance The distance of the run in miles as a double.
    :param: dateTime The time and date of the run as an NSDate object.
    :param: pace The pace of the run in seconds per mile as an Integer.
    :param: duration The duration of the run in seconds as an Integer.
    :param: shoe The shoe that the run was ran in. This object is optional.
    :param: runScore The score for the run as a double.
    :param: runLocations The array of CLLocation objects that map the route of the run.
    :param: splits The mile splits for the run as an Array of Integers in seconds per mile.
    */
    init(runID: Int, distance: Double, dateTime: NSDate, pace: Int, duration: Int, shoe: Shoe?, runScore: Double, runLocations: Array<CLLocation>?, splits: Array<Int>?) {
        self.ID = runID
        self.distance = distance
        self.dateTime = dateTime
        self.pace = pace
        self.duration = duration
        self.shoe = shoe
        self.score = runScore
        if let _locations = runLocations { //if there are locations, store them
            self.locations = _locations
        }
        if let _splits = splits { //if there are splits, store them
            self.splits = _splits
        }
    }

    /**
    This method calculates the score for a run in the following way:
    1. Creates the points from pace power as 1000 divide the pace
    2. Calculates the point from the average pace as (2.4 to the power pointsFromPacePower) * 120
    3. Creates the points from distance power as the distance divide 10
    4. Calculates the points from the distance as (2.4 to the power pointsFromDistance) * 120
    5. Calculates the total points as pointsFromDistance + pointsFromAveragePace
    6. IF the totalPoints is more than 1000
        a. Sets the score to 1000
    7. ELSE sets the score to the total points
    
    Uses the following local variables:
        pointsFromPacePower - A constant float that is the power to raise 2.4 to to calculate the points from the pace
        pointsFromAveragePace - A constant double that is the points from the average pace
        pointsFromDistancePower - A constant float that is the power to raise 2.4 to to calculate the points from the distance
        pointsFromDistance - A constant double that is the points from the distance
        totalPoints - A constant double that is the total points
    */
    func calculateRunScore() {
        let pointsFromPacePower = 1000.0/Float(self.pace) //1
        let pointsFromAveragePace = Double(pow(2.4, pointsFromPacePower) * 120) //2

        let pointsFromDistancePower = Float(self.distance)/10 //3
        let pointsFromDistance = Double(pow(2.4, pointsFromDistancePower)) * 120 //4

        let totalPoints = (pointsFromDistance + pointsFromAveragePace) //5

        if totalPoints > 1000 { //6
            self.score = 1000 //a
        } else { //7
            self.score = totalPoints
        }
    }

    // swiftlint:disable line_length
    /**
    This method adds a split to the array of stored splits for the run. This method is necessary as runs are created in an Objective-C environment (where arrays are just arrays of objects). In this case the split would have to be converted to an NSNumber object and then added to the array, so it is easy to pass the integer value for the split to the class and add it to the array in Swift.
    
    :param: split The pace of the split in seconds per mile as an integer.
    */
    // swiftlint:enable line_length
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
    
    :returns: The UIColor that represents the run's score.
    */
    func scoreColour() -> UIColor {
        if self.score < 400 { //1
            return UIColor.red //a
        } else if self.score < 700 { //2
            return UIColor.orange //b
        } else { //3
            return UIColor.green //c
        }
    }

    /**
    This method is used to calculate the different finish times for the run.
    1. Calculate the fiveK, tenK, halfMarathon and fullMarathon times as the pace times the approprite distance
    2. Converts the finish times into strings using the Conversions class
    3. Returns each of the 4 string
    
    Uses the following local variables:
        fiveK - An integer constant that is the time required to run 5k at this pace
        tenK - An integer constant that is the time reuired to run 10k at this pace
        halfMarathon - An integer constant that is the time reuired to run a half marathon at this pace
        fullMarathon - An integer constant that is the time reuired to run a full marathon at this pace
        fiveKStr - A constant string that is the time required to run 5k as a string
        tenKStr - A constant string that is the time required to run 10k as a string
        halfMarathonStr - A constant string that is the time required to run a half marathon as a string
        fullMarathonStr - A constant string that is the time required to run a full marathon as a string
    
    :returns: fiveK - The 5k finish time as a String.
    :returns: tenK - The 10k finish time as a String.
    :returns: halfMarathon - The Half Marathon finish time as a String.
    :returns: fullMarathon - The Full Marathon finish time as a String.
    */
    // swiftlint:disable large_tuple
    func calculateRunFinishTimes() -> (fiveK: String, tenK: String, halfMarathon: String, fullMarathon: String) {
        let fiveK = Int(Double(self.pace) * 3.1) //1
        let tenK = Int(Double(self.pace) * 6.2)
        let halfMarathon = Int(Double(self.pace) * 13.1)
        let fullMarathon = Int(Double(self.pace) * 26.2)

        let fiveKStr = Conversions().runDurationForInterface(duration: fiveK) //2
        let tenKStr = Conversions().runDurationForInterface(duration: tenK)
        let halfMarathonStr = Conversions().runDurationForInterface(duration: halfMarathon)
        let fullMarathonStr = Conversions().runDurationForInterface(duration: fullMarathon)

        return (fiveKStr, tenKStr, halfMarathonStr, fullMarathonStr) //3
    }
    // swiftlint:enable large_tuple

    /**
    This method determines whether a created run object is valid. It returns a boolean value based on the result of the test.
    1. IF the distance, duration and pace are all greater than nothing (this is to handle the case where a run returned from Strava has erroneous values e.g. -1)
        a. Return true
    2. ELSE return false
    
    :returns: A boolean value that indicates if the run is valid or not.
    */
    func valid() -> Bool {
        if self.distance > 0 && self.duration > 0 && self.pace > 0 {
            return true
        } else {
            return false
        }
    }

    /**
    This method prints a description of the run object for use in testing.
    
    :returns: The run's description as a string.
    */
    override var description: String {
        return "ID = '\(self.ID)', DateTime = '\(self.dateTime.description)', Pace = '\(self.pace)', Duration = '\(self.duration)', Score = '\(self.score)', Number of locations = '\(self.locations.count)', Number of splits = '\(self.splits.count)'"
    }
}
