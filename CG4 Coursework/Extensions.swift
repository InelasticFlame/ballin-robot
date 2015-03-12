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

    /**
    This extension is used to add a dark gray border to a view.
    1. Sets the borderWidth the the border width passed when the function was called
    2. Sets the border colour to dark gary
    */
    func addBorder(borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth //1
        self.layer.borderColor = UIColor.darkGrayColor().CGColor //2
    }
    
}

extension NSDate {
    
    //MARK: Convenience Initialisers
    
    /**
    This initialiser takes a date string in the form "dd/MM/yyyy" and creates a new NSDate object with this date.
    1. Creates the date formatter
    2. Sets the date format to "dd/MM/yyyy"
    3. Sets the locale to the current locale
    4. Creates the new date using the date formatter
    5. Calls the init with timeInterval sinceDate initialiser passing the created date and a time interval of 0
    */
    convenience init (shortDateString: String) {
        let dateFormatter = NSDateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyy" //2
        dateFormatter.locale = NSLocale.currentLocale() //3
        
        let newDate = dateFormatter.dateFromString(shortDateString) //4
        self.init(timeInterval: 0, sinceDate: newDate!) //5
    }
    
    /**
    This initialiser takes a date string in the form "dd/MM/yyyyHH:mm:ss" and creates a new NSDate object with this date, this is used when a run is loaded from the database.
    1. Creates the date formatter
    2. Sets the date format to "dd/MM/yyyyHH:mm:ss"
    3. Sets the locale to the current locale
    4. Creates the new date using the date formatter
    5. Calls the init with timeInterval sinceDate initialiser passing the created date and a time interval of 0
    */
    convenience init (databaseString: String) {
        let dateFormatter = NSDateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss" //2
        dateFormatter.locale = NSLocale.currentLocale() //3
        
        let newDate = dateFormatter.dateFromString(databaseString) //4
        self.init(timeInterval: 0, sinceDate: newDate!) //5
    }

    //MARK: Methods
    
    /**
    Returns the date in the form "dd/MM/yyyyHH:mm:ss" as string for saving to the database.
    1. Creates a date formatter
    2. Sets the date format
    3. Returns the string created by the date formatter
    */
    func databaseString() -> String {
        let dateFormatter = NSDateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss" //2
        
        return dateFormatter.stringFromDate(self) //3
    }
    
    /**
    Returns the date in the form "dd/MM/yyyy" as string for display on the interface.
    1. Creates a date formatter
    2. Sets the date format
    3. Returns the string created by the date formatter
    */
    func shortDateString() -> String {
        let dateFormatter = NSDateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyy" //2
        
        return dateFormatter.stringFromDate(self) //3
    }
    
    /**
    Returns the date in the form "dd/MM/YY" (e.g. 23/10/14) as string for display on the interface.
    1. Creates a date formatter
    2. Sets the date format
    3. Returns the string created by the date formatter
    */
    func shortestDateString() -> String {
        let dateFormatter = NSDateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/YY" //2
        
        return dateFormatter.stringFromDate(self) //3
    }
    
    /**
    Returns the date in the form "MM/yyyy"; this is used to search the database for runs in a specific month.
    1. Creates a date formatter
    2. Retrieves the month as an integer using the calendar of the date formatter
    3. Retrieves the year as an integer using the calendar of the date formatter
    4. Creates the monthYear string 
    5. Returns the monthYearString
    */
    func monthYearString() -> String {
        let dateFormatter = NSDateFormatter() //1
        let month = dateFormatter.calendar.component(.MonthCalendarUnit, fromDate: self) //2
        let year = dateFormatter.calendar.component(.YearCalendarUnit, fromDate: self) //3
        
        let monthYearString = NSString(format: "%02i/%04i", month, year) //4
        
        return monthYearString //5
    }

    /**
    Returns the date in the form 12 hour time format (e.g. 01:56 pm)
    1. Creates the date formatter
    2. Sets the date format
    3. Sets the locale to the current locale
    4. Returns the string created by the date formatter
    */
    func timeString12Hour() -> String {
        let dateFormatter = NSDateFormatter() //1
        dateFormatter.dateFormat = "hh:mm a" //2
        dateFormatter.locale = NSLocale.currentLocale() //3
        
        return dateFormatter.stringFromDate(self) //4
    }
    
    /**
    Returns true if a date is in today.
    1. Creates a gregorian calendar
    2. Returns the boolen created by the calendar.
    */
    func isToday() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) //1
        
        return calendar!.isDateInToday(self) //2
    }
    
    /**
    Returns true if a date was yesterday.
    1. Creates a gregorian calendar
    2. Returns the boolen created by the calendar.
    */
    func isYesterday() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) //1
        
        return calendar!.isDateInYesterday(self) //2
    }
}

extension CLLocation {
    
    //MARK: Convenience Initialisers
    
    /**
    Initialises a new CLLocation object using a string in the form "lat, long"
    1. Splits the location string on the ', ' and stores the first half as the latitude string
    2. Splits the location string on the ', ' and stores the last half as the longitude string
    3. Initialises the CLLocation object using the double values of the latitude and longitude strings
    */
    convenience init (locationString: String) {
        let latString = locationString.componentsSeparatedByString(", ").first! as NSString //1
        let longString = locationString.componentsSeparatedByString(", ").last! as NSString //2
        
        self.init(latitude: latString.doubleValue, longitude: longString.doubleValue) //3
    }
}

extension String {
    
    /**
    This function checks that a string is valid. It takes the arguemnts stringName (the name of the string being checked), maxLength (the maximum length of the string) and minLength (the minimum length of the string)
    1. Declares the local variable error as a string
    2. Creates the regular expression to check the string with; in this case the letters A to z, numbers 0 to 9, ?!. are allowed.
    3. Removes all the spaces in the string and stores it as testString
    4. IF there are less characters in the string than the minimum length
        a. Sets the error
        b. Returns false and the error
    5. IF there are more characters in the string than the maximum length
        a. Sets the error
        b. Returns false and the error
    6. IF a predicate is successfully created using the regular expression
        a. Sets the error
        b. Returns the result of the predicate evaluating the test string and the error
    7. In the default case returns false and the error
    */
    func validateString(stringName: String, maxLength: Int, minLength: Int) -> (valid: Bool, error: String) {
        var error = "Error testing string." //1
        let regEx = "[A-Z0-9a-z?!.]*" //2
        let testString = self.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil) //3
        
        if countElements(self) < minLength { //4
            error = "\(stringName) must contain at least \(minLength) letters or numbers." //4a
            return (false, error) //4b
        } else if countElements(self) > maxLength { //5
            error = "\(stringName) must be no longer than \(maxLength) characters." //5
            return (false, error) //5b
        } else if let stringTester = NSPredicate(format: "SELF MATCHES %@", regEx) { //6
            error = "\(stringName) must only contain letters, numbers or ?!." //6a
            return (stringTester.evaluateWithObject(testString), error) //6b
        }
        
        return (false, error) //7

    }
}

extension HKHealthStore {
    
    /**
    This extension retrieves the most recent sample of a given type. By retrieving the most recent sample, if there have been multiple weight updates in one day (e.g. 10am; 72.3 kg and then 5pm; 72.2 kg) the final update for the day will be returned (72.2 kg) ensure that the data is as up to date as it can be for that day
    1. Declares the local constant sortDescriptor as a NSSortDescripter by the sample end date descending
    2. Decalres the constant HKSampleQuery, query with the following settings
        * The passed sample type, the passed predicate, a limit of 1 result and the sortDescriptor *
    3. On completion performs the block
        B1. IF there is an error
            Ba. Perform the passed completion block passing nil for the result and the error
        B2. IF there is a result
            Bb. Perform the passed completion block passing the first result as a HKSample, and nil for the error
        B3. ELSE
            Bc. Perform the completion block with a nil sample and nil error
    4. Execute the query
    */
    func retrieveMostRecentSample(sampleType: HKSampleType, predicate: NSPredicate?, completion: ((HKSample!, NSError!) -> Void)!) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false) //1

        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) -> Void in //2, 3
            /* BLOCK START */
            
            if let error = error { //B1
                completion(nil, error) //Ba
                return
            }
            
            if results.first != nil { //B2
                completion(results.first as HKSample, nil) //Bb
            } else { //B3
                completion(nil, nil) //Bc
            }
            /* BLOCK END */
        }
        
        self.executeQuery(query) //4
    }
    
    /**
    This extension retrieves the sum of a group of samples (i.e. all the individual calorie inputs for a particular day)
    1. Declares constant HKSampleQuery, query, with the following settings
        * The passed quantityType, the passed predicate and the option of a cumulative sum *
    2. On completion of the query, performs the block
        B1. Decalres the local constant HKQuantity, sum, which is the total of the results
        B2. IF there is an error
            Ba. Perform the passed completion block passing nil for the result and the error
        B3. IF there is a sum
            Bb. Perform the passed completion block passing the doubleValue of the sum for the given unit for the result and nil for the error
        B4. ELSE
            Bc. Perform the passed completion block passing 0 for the sum and nil for the error
    3. Execture the query
    */
    func retrieveSumOfSample(quantityType: HKQuantityType, unit: HKUnit, predicate: NSPredicate?, completion: ((Double!, NSError!) -> Void)!) {
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .CumulativeSum) { (query, result, error) in //1, 2
            
            let sum = result.sumQuantity() //B1
            
            if error != nil { //B2
                completion(nil, error) //Ba
                return
            }
            
            if let sum = sum { //B3
                completion(sum.doubleValueForUnit(unit), nil) //Bb
            } else { //B4
                completion(0, nil)
            }
        }
        
        self.executeQuery(query) //3
    }
}