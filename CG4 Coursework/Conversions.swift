//
//  Conversions.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Conversions: NSObject {
    
    //MARK: - Conversion Constants
    
    let kmToMiles = 0.621371192 //Constant double, used to convert kilometres into miles
    let milesToKm = 1.609344 //Constant double, used to convert miles into kilometres
    let poundsToKg = 0.453592 //Constant double, used to convert pounds into kilograms
    let kgToPounds = 2.20462 //Constant double, used to convert kilograms to pounds

    //MARK: - Conversion Methods
    
    /**
    This method takes an input of a speed in metres per second and converts it into seconds per mile.
    1. Converts to metresPerHour
    2. Converts to kilometres per hour
    3. Converts to miles per hour
    4. Converts to seconds per mile
    5. Returns the seconds per mile
    
    :param: metresPerSec A double value that is the number of metres per second to convert.
    :retruns: A double value of the speed in seconds per mile.
    */
    func metresPerSecondToSecondsPerMile(metresPerSec: Double) -> Double {
        let metresPerHour = metresPerSec * 3600 //1
        let kmPerHour: Double = metresPerHour/1000 //2
        let milesPerHour: Double = kmPerHour * kmToMiles //3
        let secPerMile = 3600/milesPerHour //4
        
        return secPerMile //5
    }
    
    /**
    This method takes a distance in metres and returns it as a distance in miles.
    1. Converts the meters into kilometres and then converts into miles
    2. Returns the miles
    
    :param: meters A double value that is the number of metres to convert.
    :returns: A double value of the distance in metres.
    */
    func metresToMiles(meters: Double) -> (Double) {
        let miles = (meters/1000)*kmToMiles
    
        return miles
    }
    
    //MARK: - Stringify Methods
    
    /**
    This method takes a run pace as an integer and then converts it into a string to display on the interface based on a user's unit preference.
    1. Declares the local string variable paceString
    2. Declares the local constant string paceUnit which is the stored string in the userDefaults for the pace unit
    3. IF the paceUnit is the min per mile unit or there is no unit
        a. Let minutes equal the pace divided by 60 as an integer
        b. Let seconds equal the pace modulus 60 as an integer
        c. Return string is in the form "mm:ss min/mile"
    4. IF the paceUnit is km/h unit
        a. Let miles per hour equal 1 hour divided by the pace
        b. Let kilometres per hour equal the miles per hour times milesToKm
        c. Return string is in the form "kmh to 2 decimal places km/h"
    5. Return the paceString
    
    :param: pace An integer value that is the pace to convert to a string.
    :returns: The pace as a string (using the user's chosen unit).
    */
    func averagePaceForInterface(pace: Int) -> String {
        var paceString = ""
        let paceUnit = NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.Pace.UnitKey)
        
        if paceUnit == Constants.DefaultsKeys.Pace.MinMileUnit || paceUnit == "" {
            let minutes = pace/60
            let seconds = pace % 60
            paceString = NSString(format: "%02i:%02i", minutes, seconds) + " min/mile"
        } else if paceUnit == Constants.DefaultsKeys.Pace.KMPerH {
            let mph = 3600.0/Double(pace)
            let kmh = Double(mph) * milesToKm
            paceString = NSString(format: "%1.2f", kmh) + " km/h"
        }
        
        return paceString
    }
    
    /**
    This method takes a run duration as an integer and then converts it into a string to display on the interface.
    1. Declares the local string variable durationString
    2. Let hours equal the duration divided by 3600 seconds as an integer
    3. Let the minutes (in terms of seconds) equal the duration modulus 3600 as an integer
    4. Let the minutes equal the minutesInSeconds divided by 60 as an integer
    5. Let the seconds equal the duration modulus 60 as an integer
    6. IF the hours is greater than 0
        a. Return string is in the form "h:mm:ss"
    7. ELSE
        b. Return string is in the form "mm:ss"
    8. Return the durationString
    
    :param: duration An integer value that is the duration to convert to a string.
    :returns: The duration as a string.
    */
    func runDurationForInterface(duration: Int) -> String {
        var duratonString = "" //1
        let hours = duration/3600 //2
        let minutesInSeconds = duration % 3600 //3
        let minutes = minutesInSeconds/60 //4
        let seconds = duration % 60 //5
        
        if hours > 0 { //6
            duratonString = NSString(format: "%ih %02im %02is", hours, minutes, seconds) //a
        } else { //7
            duratonString = NSString(format: "%02im %02is", minutes, seconds) //b
        }
        
        return duratonString //8
    }
    
    /**
    This method is used to convert a distance as a double and convert it into a string to display on the interface based on a user's unit perference.
    1. Declares the local string variable distanceString
    2. Declares the local constant distanceUnit which is the stored string in the userDefaults for the distance unit
    3. IF the distanceUnit is the mile unit or there is no stored unit
        a. Return string is in the form "distance to 2 decimal places miles"
    4. ELSE IF the distanceUnit is the km unit
        b. Let kilometres equal the distance times the milesToKm conversion
        c. Return string is in the form "kilometres to 2 decimal places km"
    5. Return the distanceString
    
    :param: distance A double value that is the distance to convert to a string.
    :returns: The distane as a string (based on the user's unit perference).
    */
    func distanceForInterface(distance: Double) -> String {
        var distanceString = "" //1
        let distanceUnit = NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.Distance.UnitKey) //2
        
        if distanceUnit == Constants.DefaultsKeys.Distance.MilesUnit || distanceUnit == "" { //3
            distanceString = NSString(format: "%1.2f", distance) + " miles" //a
        } else if distanceUnit == Constants.DefaultsKeys.Distance.KmUnit { //4
            let kilometres = distance * milesToKm //b
            distanceString = NSString(format: "%1.2f", kilometres) + " km" //c
        }
        
        return distanceString //5
    }
    
    //MARK: - Array Sorting
    
    /**
    This method takes an array of Run objects and returns the total of their distances.
    1. Declares the local variable total which tracks the current total distance
    2. For each run object in the array, runs
        a. Increases the total by the run's distance
    3. Returns the total
    
    :param: runs An array of Run objects that distances are to be summed.
    :returns: A double value of the sum of the run distances.
    */
    func totalUpRunMiles(runs: Array<Run>) -> Double {
        var total = 0.0 //1
        for run: Run in runs { //2
            total += run.distance //a
        }
        
        return total //3
    }
    
    /**
    This method sorts an array of Run objects into order of their dates.
    1. Sorts the array based on the dateTime; runs with a smaller timeIntervalSinceNow (e.g. how long ago it was) go at the lowest index
    2. Returns the array of sorted runs
    
    :param: runs (called array locally): an array of Run objects that are to be sorted by their dates.
    :returns: An array of Run objects in date order.
    */
    func sortRunsIntoDateOrder(runs array: Array<Run>) -> Array<Run> {
        
        var runs = array //Create a mutable version of the array
        
        runs.sort({$0.dateTime.timeIntervalSinceNow > $1.dateTime.timeIntervalSinceNow}) //1
        
        return runs //2
    }
    
    /**
    This method sorts an array of Planned Run objects into order of their dates.
    1. Sorts the array based on the dateTime; runs with a smaller timeIntervalSinceNow (e.g. how long ago it was) go at the lowest index
    2. Returns the array of sorted plannedRuns
    
    :param: plannedRuns (called array locally): an array of Planned Run objects that are to be sorted by their dates.
    :returns: An array of PlannedRun objects in date order.
    */
    func sortPlansIntoDateOrder(plannedRuns array: Array<PlannedRun>) -> Array<PlannedRun> {
        var plannedRuns = array //Create a mutable copy of the array
        
        plannedRuns.sort({$0.date.timeIntervalSinceNow < $1.date.timeIntervalSinceNow}) //1
        
        return plannedRuns //2
    }
}