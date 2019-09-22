//
//  Run.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

@objc class Run: NSObject {

    // MARK: - Properties

    var ID: Int
    var dateTime: Date
    var shoe: Shoe?
    var locations = [CLLocation]()
    var splits = [Int]()

    var distance: Distance<Miles>
    var rawDistance: Double { return distance.rawValue }

    var rawPace: Int { return Int(pace.rawValue * 3600) }
    var pace: Speed<MinutesPerMile>

    var duration: Duration<Seconds>
    var rawDuration: Int { return Int(duration.rawValue) }

    var score: RunScore
    var runScore: Double { return score.value }

    // MARK: - Initialisation

    override init() {
        self.ID = 0
        self.distance = 0.miles
        self.dateTime = Date()
        self.pace = 0.minutesPerMile
        self.duration = 0.secs
        self.score = RunScore(0)
    }

    /**
    Called to initialise the class, sets the properties of the Run to the passed values.
    
    :param: runID The ID of the run.
    :param: distance The distance of the run in miles as a double.
    :param: dateTime The time and date of the run as an Date object.
    :param: pace The pace of the run in seconds per mile as an Integer.
    :param: duration The duration of the run in seconds as an Integer.
    :param: shoe The shoe that the run was ran in. This object is optional.
    :param: runScore The score for the run as a double.
    :param: runLocations The array of CLLocation objects that map the route of the run.
    :param: splits The mile splits for the run as an Array of Integers in seconds per mile.
    */
    init(runID: Int, distance: Distance<Miles>, dateTime: Date, pace: Speed<MinutesPerMile>, duration: Duration<Seconds>, shoe: Shoe?, runScore: Double, runLocations: Array<CLLocation>?, splits: Array<Int>?) {
        self.ID = runID
        self.distance = distance
        self.dateTime = dateTime
        self.pace = pace
        self.duration = duration
        self.shoe = shoe
        self.score = RunScore(runScore)
        if let _locations = runLocations { //if there are locations, store them
            self.locations = _locations
        }
        if let _splits = splits { //if there are splits, store them
            self.splits = _splits
        }
    }

    // TEMP to maintain database compat
    init(runID: Int, distanceInMiles: Double, dateTime: Date, pace: Int, duration: Int, shoe: Shoe?, runScore: Double, runLocations: Array<CLLocation>?, splits: Array<Int>?) {
        self.ID = runID
        self.distance = distanceInMiles.miles
        self.dateTime = dateTime
        self.pace = pace.secondsPerMile.toMinutesPerMile()
        self.duration = duration.secs
        self.shoe = shoe
        self.score = RunScore(runScore)
        if let _locations = runLocations { //if there are locations, store them
            self.locations = _locations
        }
        if let _splits = splits { //if there are splits, store them
            self.splits = _splits
        }
    }

    @objc func calculateRunScore() {
        self.score = RunScorer.score(run: self)
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
    Calculate 5k, 10k, half marathon and full marathon finish times at this run's pace.
    
    :returns: fiveK - The 5k finish time as a String.
    :returns: tenK - The 10k finish time as a String.
    :returns: halfMarathon - The Half Marathon finish time as a String.
    :returns: fullMarathon - The Full Marathon finish time as a String.
    */
    // swiftlint:disable large_tuple
    func calculateRunFinishTimes() -> (fiveK: String, tenK: String, halfMarathon: String, fullMarathon: String) {
        let fiveK = Int((self.pace * 3.1).rawValue) //1
        let tenK = Int((self.pace * 6.2).rawValue)
        let halfMarathon = Int((self.pace * 13.1).rawValue)
        let fullMarathon = Int((self.pace * 26.2).rawValue)

        let fiveKStr = Conversions().runDurationForInterface(duration: fiveK) //2
        let tenKStr = Conversions().runDurationForInterface(duration: tenK)
        let halfMarathonStr = Conversions().runDurationForInterface(duration: halfMarathon)
        let fullMarathonStr = Conversions().runDurationForInterface(duration: fullMarathon)

        return (fiveKStr, tenKStr, halfMarathonStr, fullMarathonStr) //3
    }
    // swiftlint:enable large_tuple

    /**
    This is to handle the case where a run returned from Strava has erroneous values e.g. -1
    */
    @objc func valid() -> Bool {
        if self.distance > 0.miles && self.duration > 0.secs && self.pace > 0.minutesPerMile {
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
