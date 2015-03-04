//
//  Extensions.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit
import HealthKit

extension UIView {
   
    //MARK: Methods

    func addBorder(borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.masksToBounds = true
    }
    
}

extension NSDate {
    
    //MARK: Convenience Initialisers
    
    convenience init (shortDateString: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = NSLocale.currentLocale()
        
        let newDate = dateFormatter.dateFromString(shortDateString)
        self.init(timeInterval: 0, sinceDate: newDate!)
    }
    
    convenience init (databaseString: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss"
        dateFormatter.locale = NSLocale.currentLocale()
        
        let newDate = dateFormatter.dateFromString(databaseString)
        self.init(timeInterval: 0, sinceDate: newDate!)
    }

    //MARK: Methods
    
    func databaseString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss"
        
        return dateFormatter.stringFromDate(self)
    }
    
    func shortDateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.stringFromDate(self)
    }
    
    func shortestDateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        
        return dateFormatter.stringFromDate(self)
    }
    
    func monthYearString() -> String {
        let dateFormatter = NSDateFormatter()
        let month = dateFormatter.calendar.component(.MonthCalendarUnit, fromDate: self)
        let year = dateFormatter.calendar.component(.YearCalendarUnit, fromDate: self)
        
        let monthString = NSString(format: "%02i/%04i", month, year)
        
        return monthString

    }
    
    func isToday() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        return calendar!.isDateInToday(self)
    }
    
    func isYesterday() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        return calendar!.isDateInYesterday(self)
    }
    
    func isTomorrow() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        return calendar!.isDateInTomorrow(self)
    }
}

extension CLLocation {
    
    //MARK: Convenience Initialisers
    
    convenience init (locationString: String) {
        let latString = locationString.componentsSeparatedByString(", ").first! as NSString
        let longString = locationString.componentsSeparatedByString(", ").last! as NSString
        
        self.init(latitude: latString.doubleValue, longitude: longString.doubleValue)
    }
}

extension String {
    
    /**
    UPDATE FOR GENERAL
    This method checks that a plan name is valid.
    1. Declares and initialises the regular expression to check the string against; the string is valid for all letters A to Z (in both upper and lower case), all numbers and the symbols ?!.
    2. Declares and initialises the local variable planName, setting its value to the text in the planNameTextField with all spaces removed.
    3. IF the planName contains nothing
    a. Sets the text of the warning label
    b. Returns false
    4. Declares and creates a NSPredicate to test the string against the regular expression, IF it is created
    a. Sets the text of the warning label
    b. Returns the evaluation of the NSPredicate on the planName
    5. In the default case, returns false
    */
    func validateString(stringName: String, maxLength: Int, minLength: Int) -> (valid: Bool, error: String) {
        var error = ""
        let regEx = "[A-Z0-9a-z?!.]*" //1
        let testString = self.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil) //2
        
        if countElements(testString) < minLength { //3
            error = "\(stringName) must contain at least \(minLength) letters or numbers." //a
            return (false, error) //b
        } else if countElements(testString) > maxLength {
            error = "\(stringName) must be no longer than \(maxLength) characters."
            return (false, error)
        } else if let stringTester = NSPredicate(format: "SELF MATCHES %@", regEx) { //4
            error = "\(stringName) must only contain letters, numbers or ?!." //a
            return (stringTester.evaluateWithObject(testString), error) //b
        }
        
        return (false, error) //5

    }
}

extension HKHealthStore {
    
    //By retrieving the most recent sample, if there have been multiple weight updates in one day (e.g. 10am; 72.3 kg and then 5pm; 72.2 kg) the final update for the day will be returned (72.2 kg) ensure that the data is as up to date as it can be for that day
    func retrieveMostRecentSample(sampleType: HKSampleType, predicate: NSPredicate?, completion: ((HKSample!, NSError!) -> Void)!) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) -> Void in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            if completion != nil && results.first != nil {
                completion(results.first as HKSample, nil)
            }
        }
        
        self.executeQuery(query)
    }
    
    
    func retrieveSumOfSample(sampleType: HKQuantityType, unit: HKUnit, predicate: NSPredicate?, completion: ((Double!, NSError!) -> Void)!) {
        
        let query: HKStatisticsQuery = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: HKStatisticsOptions.CumulativeSum) { (query, result, error) in
            
            let sum = result.sumQuantity()
            
            if (completion != nil) {
                if let sum = sum {
                    completion(sum.doubleValueForUnit(unit), nil)
                } else {
                    completion(0, nil)
                }
            } else if (error != nil) {
                completion(nil, error)
            }
            
        }
        
        self.executeQuery(query)
    }
}