//
//  Conversions.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Conversions: NSObject {
    
    let kmToMiles = 0.621371192 //Constant double, used to convert kilometres into miles
    let milesToKm = 1.609344 //Constant double, used to convert miles into kilometres
    let poundsToKg = 0.453592 //Constant double, used to convert pounds into kilograms
    
    func addBorderToView(view: UIView) {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGrayColor().CGColor
        view.layer.masksToBounds = true
    }
    
    //MARK: - Conversion Methods
    
    /**
    This method takes an input of a speed in metres per second and converts it into seconds per mile.
    */
    func metresPerSecondToSecondsPerMile(metresPerSec: Double) -> (Double) {
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
    
    /**
    This method takes a date-time string in the form "dd/MM/yyyyHH:mm:ss" and returns it as an NSDate object.
    */
    func stringToDateAndTime(dateTimeStr: String) -> NSDate? {
        var dateFormatter = NSDateFormatter() //Create the NSDateFormatter
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss" //Set the date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") //Set the locale
        let date = dateFormatter.dateFromString(dateTimeStr) //Create the date
        
        return date //Return the date
    }
    
    /**
    This method takes a location string in the form "latitude, longitude" and returns it as a CLLocation object.
    */
    func stringToLocation(locationString: String) -> CLLocation {
        let latString = locationString.componentsSeparatedByString(", ").first! as NSString
        let longString = locationString.componentsSeparatedByString(", ").last! as NSString
        let locationQuantity = CLLocation(latitude: latString.doubleValue, longitude: longString.doubleValue)
        
        return locationQuantity
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
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
    
    func dateTimeToStringForDB(dateTime: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss"
        
        return dateFormatter.stringFromDate(dateTime)
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
    
    /**
    
    */
    func dateToMonthString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        let month = dateFormatter.calendar.component(.MonthCalendarUnit, fromDate: date)
        let year = dateFormatter.calendar.component(.YearCalendarUnit, fromDate: date)
        
        let monthString = NSString(format: "%02i/%04i", month, year)
        
        return monthString
    }
    
    //MARK: - Runs
    
    /**
    This method returns the colour for the progress bar based on a run's score.
    Red < 300
    Orange 300 <= score < 700
    Green >= 700
    */
    func returnScoreColour(run: Run) -> UIColor {
        if run.score < 300 {
            return UIColor.redColor()
        } else if run.score < 700 {
            return UIColor.orangeColor()
        } else {
            return UIColor.greenColor()
        }
    }
    
    /**
    
    */
    func calculateRunFinishTimes(run: Run) -> (fiveK : String, tenK: String, halfMarathon: String, fullMarathon: String) {
        let fiveK = Int(Double(run.pace) * 3.1)
        let tenK = Int(Double(run.pace) * 6.2)
        let halfMarathon = Int(Double(run.pace) * 13.1)
        let fullMarathon = Int(Double(run.pace) * 26.2)
        
        let fiveKStr = "5k: " + runDurationForInterface(fiveK)
        let tenKStr = "10k: " + runDurationForInterface(tenK)
        let halfMarathonStr = "Half: " + runDurationForInterface(halfMarathon)
        let fullMarathonStr = "Full: " + runDurationForInterface(fullMarathon)
        
        return (fiveKStr, tenKStr, halfMarathonStr, fullMarathonStr)
    }
    
    /**
    Checks a run is valid; that is, it has a distance, duration and pace greater than 0.
    */
    func validateRun(run: Run) -> Bool {
        if run.distance > 0 && run.duration > 0 && run.pace > 0 {
            return true
        } else {
            return false
        }
    }
}
