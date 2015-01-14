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
    
    func sortRunsIntoDateOrder(runs array: Array<Run>) -> Array<Run> {
        var runs = array //Create a mutable version of the array
        
        runs.sort({$0.dateTime.timeIntervalSinceNow > $1.dateTime.timeIntervalSinceNow})
        
        return runs
    }
    
    func metresPerSecondToMinPerMile(metresPerSec: Double) -> (Double) {
        let metresPerHour = metresPerSec * 3600
        let kmPerHour = metresPerHour/1000
        let milesPerHour = kmPerHour * kmToMiles
        let secPerMile = 3600/milesPerHour
        
        return secPerMile
    }
    
    func addBorderToView(view: UIView) {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGrayColor().CGColor
        view.layer.masksToBounds = true
    }
    
    func averagePaceForInterface(pace: Int) -> String {
        var returnValue = ""
        var paceUnit = NSUserDefaults.standardUserDefaults().stringForKey("paceUnit")
        paceUnit = "min/miles"
        
        if paceUnit == "min/miles" {
            let minutes = pace/60
            let seconds = pace % 60
            returnValue = NSString(format: "%02i:%02i", minutes, seconds) + " min/mile"
        } else if paceUnit == "km/h" {
            let mph = 3600/pace
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
        
        returnValue = NSString(format: "%02i:%02i:%02i", hours, minutes, seconds)
        
        return returnValue
    }
    
    func distanceForInterface(distance: Double) -> String {
        var returnValue = ""
        var distanceUnit = NSUserDefaults.standardUserDefaults().stringForKey("distanceUnit")
        distanceUnit = "miles"
        
        if distanceUnit == "miles" {
            returnValue = "\(distance) miles"
            
        } else if distanceUnit == "km" {
            let kilometers = distance * milesToKm
            returnValue = NSString(format: "%1.2f", kilometers) + " km"
        }
        
        return returnValue
    }

    func metresToMiles(metres: Double) -> (Double) {
        let miles = (metres/1000)*kmToMiles
        
        return miles
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
    
    func timeForInterface(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = NSLocale.currentLocale()
        
        return dateFormatter.stringFromDate(date)
    }
    
    func stringToDateAndTime(dateTimeStr: String) -> NSDate? {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        let date = dateFormatter.dateFromString(dateTimeStr)
        
        return date
    }
    
    func stringToLocation(locationString: String) -> CLLocation {
        let latString = locationString.componentsSeparatedByString(", ").first
        let longString = locationString.componentsSeparatedByString(", ").last
        let locationQuantity = CLLocation(latitude: 0, longitude: 0)

        return locationQuantity
    }
    
    func totalUpRunMiles(runs: Array<Run>) -> Double {
        var total = 0.0
        for run: Run in runs {
            total += run.distance
        }
        
        return total
    }
    
    func returnScoreColour(run: Run) -> UIColor {
        if run.score < 300 {
            return UIColor.redColor()
        } else if run.score < 700 {
            return UIColor.orangeColor()
        } else {
            return UIColor.greenColor()
        }
    }
    
    func dateToMonthString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        let month = dateFormatter.calendar.component(.MonthCalendarUnit, fromDate: date)
        let year = dateFormatter.calendar.component(.YearCalendarUnit, fromDate: date)
        
        let monthString = NSString(format: "%02i/%04i", month, year)
        
        return monthString
    }
    
    func validateRun(run: Run) -> Bool {
        if run.distance > 0 && run.duration > 0 && run.pace > 0 {
            return true
        } else {
            return false
        }
    }
}
