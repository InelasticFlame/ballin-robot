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
    
    //MARK: - Conversion Methods
    
    /**
    This method takes an input of a speed in metres per second and converts it into seconds per mile.
    */
    func metresPerSecondToSecondsPerMile(metresPerSec: Double) -> Double {
        let metresPerHour = metresPerSec * 3600
        let kmPerHour = metresPerHour/1000
        let milesPerHour = kmPerHour * kmToMiles
        let secPerMile = 3600/milesPerHour
        
        return secPerMile
    }
    
    /**
    This method takes a distance in metres and returns it as a distance in miles
    */
    func metresToMiles(metres: Double) -> (Double) {
        let miles = (metres/1000)*kmToMiles
        
        return miles
    }
    
    //MARK: - Stringify Methods
    
    /**
    
    */
    func averagePaceForInterface(pace: Int) -> String {
        var returnValue = ""
        var paceUnit = NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.Pace.UnitKey)
        
        if paceUnit == "min/miles" {
            let minutes = pace/60
            let seconds = pace % 60
            returnValue = NSString(format: "%02i:%02i", minutes, seconds) + " min/mile"
        } else if paceUnit == "km/h" {
            let mph = 3600.0/Double(pace)
            let kmh = Double(mph) * milesToKm
            returnValue = NSString(format: "%1.2f", kmh) + " km/h"
        }
        
        return returnValue
    }
    
    func runDurationForInterface(duration: Int) -> String {
        var returnValue = ""
        let hours = duration/3600
        let minutesInSeconds = duration % 3600
        let minutes = minutesInSeconds/60
        let seconds = duration % 60
        
        if hours > 0 {
            returnValue = NSString(format: "%ih %02im %02is", hours, minutes, seconds)
        } else {
            returnValue = NSString(format: "%02im %02is", minutes, seconds)
        }
        
        return returnValue
    }
    
    func distanceForInterface(distance: Double) -> String {
        var returnValue = ""
        var distanceUnit = NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.Distance.UnitKey)
        
        if distanceUnit == "miles" {
            returnValue = "\(distance) miles"
            
        } else if distanceUnit == "kilometres" {
            let kilometers = distance * milesToKm
            returnValue = NSString(format: "%1.2f", kilometers) + " km"
        }
        
        return returnValue
    }
    
    /**
    This method takes an NSDate object and returns the time as a string, in the form "hh:mm" using the 12 hour system.
    */
    func timeForInterface(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = NSLocale.currentLocale()
        
        return dateFormatter.stringFromDate(date)
    }
    
    //MARK: - Array Sorting
    
    /**
    This method takes an array of Run objects and returns the total of their distances.
    */
    func totalUpRunMiles(runs: Array<Run>) -> Double {
        var total = 0.0
        for run: Run in runs {
            total += run.distance
        }
        
        return total
    }
    
    /**
    This method sorts an array of Run objects into order of their dates.
    */
    func sortRunsIntoDateOrder(runs array: Array<Run>) -> Array<Run> {
        //EXPLANATION: Due to Swift and Objective-C interaction a mutable array has to be created as Objective-C would not interact
        //with a function with mutable inputs. The following method was done in Swift due to the inbuilt array sort methods in Swift.
        
        var runs = array //Create a mutable version of the array
        
        runs.sort({$0.dateTime.timeIntervalSinceNow > $1.dateTime.timeIntervalSinceNow})
        
        return runs
    }
}