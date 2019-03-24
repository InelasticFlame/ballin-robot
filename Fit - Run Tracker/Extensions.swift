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
    2. Sets the border colour to dark gray
    
    :param: borderWidth A CGFloat value of the width of border to add.
    */
    func addBorder(borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth //1
        self.layer.borderColor = UIColor.darkGray.cgColor //2
    }
    
}

extension NSDate {
    
    //MARK: Convenience Initialisers
    
    /**
    This initialiser takes a date string in the form "dd/MM/yyyy" and creates a new NSDate object with this date.
    1. Creates the date formatter
    2. Sets the date format to "dd/MM/yyyy"
    3. Sets the locale to the en_GB (for consistency)
    4. Creates the new date using the date formatter
    5. Calls the init with timeInterval sinceDate initialiser passing the created date and a time interval of 0
    
    Uses the following local variables:
        dateFormatter - A constant NSDateFormatter used to create the date.
        newDate - A constant NSDate that is the created date.
    
    :param: shortDateString the date as a string to create the NSDate with.
    */
    convenience init (shortDateString: String) {
        let dateFormatter = DateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyy" //2
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale //3
        
        let newDate = dateFormatter.date(from: shortDateString) //4
        self.init(timeInterval: 0, since: newDate!) //5
    }
    
    /**
    This initialiser takes a date string in the form "dd/MM/yyyyHH:mm:ss" and creates a new NSDate object with this date, this is used when a run is loaded from the database.
    1. Creates the date formatter
    2. Sets the date format to "dd/MM/yyyyHH:mm:ss"
    3. Sets the locale to the en_GB (for consistency)
    4. Creates the new date using the date formatter
    5. Calls the init with timeInterval sinceDate initialiser passing the created date and a time interval of 0
    
    Uses the following local variables:
        dateFormatter - A constant NSDateFormatter used to create the date.
        newDate - A constant NSDate that is the created date.
    
    :param: databaseString A string of the date to create the NSDate with.
    */
    convenience init (databaseString: String) {
        let dateFormatter = DateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss" //2
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale //3
        
        let newDate = dateFormatter.date(from: databaseString) //4
        self.init(timeInterval: 0, since: newDate!) //5
    }

    //MARK: Methods
    
    /**
    This method returns the date in the form "dd/MM/yyyyHH:mm:ss" as string for saving to the database.
    1. Creates a date formatter
    2. Sets the date format
    3. Sets the locale to the en_GB (for consistency)
    4. Returns the string created by the date formatter
    
    Uses the following local variables:
        dateFormatter - A constant NSDateFormatter used to create the string.
    
    :returns: The date in the form "dd/MM/yyyyHH:mm:ss" as a string
    */
    func databaseString() -> String {
        let dateFormatter = DateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyyHH:mm:ss" //2
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale //3
        
        return dateFormatter.string(from: self as Date) //4
    }
    
    /**
    This method returns the date in the form "dd/MM/yyyy" as string for display on the interface.
    1. Creates a date formatter
    2. Sets the date format
    3. Sets the locale to the en_GB (for consistency)
    4. Returns the string created by the date formatter
    
    Uses the following local variables:
        dateFormatter - A constant NSDateFormatter used to create the string.
    
    :returns: The date in the form "dd/MM/yyyy" as a string
    */
    func shortDateString() -> String {
        let dateFormatter = DateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/yyyy" //2
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale //3
        
        return dateFormatter.string(from: self as Date) //4
    }
    
    /**
    Returns the date in the form "dd/MM/YY" (e.g. 23/10/14) as string for display on the interface.
    1. Creates a date formatter
    2. Sets the date format
    3. Sets the locale to the en_GB (for consistency)
    4. Returns the string created by the date formatter
    
    Uses the following local variables:
        dateFormatter - A constant NSDateFormatter used to create the string.
    
    :returns: The date in the form "dd/MM/yy" as a string
    */
    func shortestDateString() -> String {
        let dateFormatter = DateFormatter() //1
        dateFormatter.dateFormat = "dd/MM/YY" //2
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        return dateFormatter.string(from: self as Date) //3
    }
    
    /**
    Returns the date in the form "MM/yyyy"; this is used to search the database for runs in a specific month.
    1. Creates a date formatter
    2. Retrieves the month as an integer using the calendar of the date formatter
    3. Retrieves the year as an integer using the calendar of the date formatter
    4. Creates the monthYear string 
    5. Returns the monthYearString
    
    Uses the following local variables:
        dateFormatter - A constant NSDateFormatter used to create the string
        month - A constant integer value that stores the date's month
        year - A constant integer value that stores the date's year
        monthYearString - A constant string that stores the month year string
    
    :returns: The date in the form "/MM/yyyy" as a string
    */
    func monthYearString() -> String {
        let dateFormatter = DateFormatter() //1
        let month = dateFormatter.calendar.component(.month, from: self as Date)
        let year = dateFormatter.calendar.component(.year, from: self as Date)
        
        let monthYearString = NSString(format: "%02i/%04i", month, year) //4
        
        return monthYearString as String //5
    }

    /**
    Returns the date in the form 12 hour time format (e.g. 01:56 pm)
    1. Creates the date formatter
    2. Sets the date format
    3. Sets the locale to the en_GB (for consistency)
    4. Returns the string created by the date formatter
    
    Uses the following local variables:
        dateFormatter - A constant NSDateFormatter used to create the string
    
    :returns: The time portion of the date in the form "HH:mm a" as a string
    */
    func timeString12Hour() -> String {
        let dateFormatter = DateFormatter() //1
        dateFormatter.dateFormat = "hh:mm a" //2
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale //3
        
        return dateFormatter.string(from: self as Date) //4
    }
    
    /**
    Returns true if a date is in today.
    1. Creates a gregorian calendar
    2. Returns the boolean created by the calendar.
    
    Uses the following local variables:
        calendar - A constant NSCalendar used to test the date
    
    :returns: A boolean that indicates if the date is in today or not.
    */
    func isToday() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) //1
        
        return calendar!.isDateInToday(self as Date) //2
    }
    
    /**
    Returns true if a date was yesterday.
    1. Creates a gregorian calendar
    2. Returns the boolean created by the calendar.
    
    Uses the following local variables:
        calendar - A constant NSCalendar used to test the date
    
    :returns: A boolean that indicates if the date is in yesterday or not.
    */
    func isYesterday() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) //1
        
        return calendar!.isDateInYesterday(self as Date) //2
    }
}

extension CLLocation {
    
    //MARK: Convenience Initialisers
    
    /**
    Initialises a new CLLocation object using a string in the form "lat, long"
    1. Splits the location string on the ', ' and stores the first half as the latitude string
    2. Splits the location string on the ', ' and stores the last half as the longitude string
    3. Initialises the CLLocation object using the double values of the latitude and longitude strings
    
    Uses the following local variables:
        latString - A constant string that stores the latitude as a string
        longString - A constant string that stores the longitude as a string
    
    :param: location A string of the location to create the CLLocation object with.
    */
    convenience init (locationString: String) {
        let latString = locationString.components(separatedBy: ", ").first! as NSString //1
        let longString = locationString.components(separatedBy: ", ").last! as NSString //2
        
        self.init(latitude: latString.doubleValue, longitude: longString.doubleValue) //3
    }
}

extension String {
    
    /**
    This function checks that a string is valid.
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
    
    Uses the following local variables:
        error - A string variable that stores the validation error
        regEx - A constant string that stores the regular expression to check the string with
        testString - A constant string that is the string to be validate with space removed
    
    :param: stringName A String of the name of the string being validated.
    :param: maxLength An integer that is the maximum length of the string.
    :param: minLength An integer that is the minimum length of the string.
    :returns: valid - A boolean that indicates if the string is valid or not
    :returns: error - A string that stores the validation error (if there is one)
    */
    func validateString(stringName: String, maxLength: Int, minLength: Int) -> (valid: Bool, error: String) {
        var error = "Error testing string." //1
        let regEx = "[A-Z0-9a-z?!.]*" //2
        let testString = self.replacingOccurrences(of: " ", with: "")
        
        if self.count < minLength { //4
            error = "\(stringName) must contain at least \(minLength) letters or numbers." //4a
            return (false, error) //4b
        } else if self.count > maxLength { //5
            error = "\(stringName) must be no longer than \(maxLength) characters." //5
            return (false, error) //5b
        } else { //6
            let stringTester = NSPredicate(format: "SELF MATCHES %@", regEx)
            error = "\(stringName) must only contain letters, numbers or ?!." //6a
            return (stringTester.evaluate(with: testString), error) //6b
        }
        
        return (false, error) //7

    }
}

extension HKHealthStore {
    
    /**
    This extension retrieves the most recent sample of a given type. By retrieving the most recent sample, if there have been multiple weight updates in one day (e.g. 10am; 72.3 kg and then 5pm; 72.2 kg) the final update for the day will be returned (72.2 kg) ensure that the data is as up to date as it can be for that day
    1. Declares the local constant sortDescriptor as a NSSortDescripter by the sample end date descending
    2. Declares the constant HKSampleQuery, query with the following settings
        * The passed sample type, the passed predicate, a limit of 1 result and the sortDescriptor *
    3. On completion performs the block
        B1. IF there is an error
            Ba. Perform the passed completion block passing nil for the result and the error
        B2. IF there is a result
            Bb. Perform the passed completion block passing the first result as a HKSample, and nil for the error
        B3. ELSE
            Bc. Perform the completion block with a nil sample and nil error
    4. Execute the query
    
    Uses the following local variables:
        sortDescriptor - A constant NSSortDescriptor to filter the results using.
        query - A constant HKSampleQuery used to query the health kit datastore.
    
    :param: sampleType A HKSampleType object which is the sample to retrieve.
    :param: predicate An NSPredicate to filter the data with.
    :param: completion The block to perform on completion of the request. (The completion block has parameters of a HKSample object and an NSError object and returns nothing)
    */
    func retrieveMostRecentSample(sampleType: HKSampleType, predicate: NSPredicate?, completion: @escaping (HKSample?, NSError?) -> (Void)) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false) //1

        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) -> Void in //2, 3
            /* BLOCK START */
            
            if let error = error { //B1
                completion(nil, error as NSError) //Ba
                return
            }
            
            if let firstResult = results?.first { //B2
                completion(firstResult, nil) //Bb
            } else { //B3
                completion(nil, nil) //Bc
            }
            /* BLOCK END */
        }
        
        self.execute(query) //4
    }
    
    /**
    This extension retrieves the sum of a group of samples (i.e. all the individual calorie inputs for a particular day)
    1. Declares constant HKSampleQuery, query, with the following settings
        * The passed quantityType, the passed predicate and the option of a cumulative sum *
    2. On completion of the query, performs the block
        B1. Declares the local constant HKQuantity, sum, which is the total of the results
        B2. IF there is an error
            Ba. Perform the passed completion block passing nil for the result and the error
        B3. IF there is a sum
            Bb. Perform the passed completion block passing the doubleValue of the sum for the given unit for the result and nil for the error
        B4. ELSE
            Bc. Perform the passed completion block passing 0 for the sum and nil for the error
    3. Execute the query
    
    Uses the following local variables:
        query - A constant HKStatisticsQuery used to query the health kit datastore.
    
    :param: quantityType A HKQuantityType object which is the quantity to retrieve.
    :param: unit The HKUnit to retrieve the quantity in.
    :param: predicate An NSPredicate to filter the data with.
    :param: completion The block to perform on completion of the request. (The completion block has parameters of a Double and an NSError object and returns nothing)
    */
    func retrieveSumOfSample(quantityType: HKQuantityType, unit: HKUnit, predicate: NSPredicate?, completion: @escaping (Double?, NSError?) -> (Void)) {
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in //1, 2
            
            let sum = result!.sumQuantity() //B1
            
            if error != nil { //B2
                completion(nil, error as! NSError) //Ba
                return
            }
            
            if let sum = sum { //B3
                completion(sum.doubleValue(for: unit), nil) //Bb
            } else { //B4
                completion(0, nil)
            }
        }
        
        self.execute(query) //3
    }
    
}

extension UITableView {
    
    /**
    This function is called whenever a new row is shown/hidden in the table view. It reloads the data in the table view and animates the process.
    1. Calls the beginUpdates function of the table view, this tells the system that the following lines should be animated and performed
    2. Reloads the data in the table view
    3. Calls the endUpdates function
    */
    func reloadTableViewCells() {
        self.beginUpdates()
        self.reloadData()
        self.endUpdates()
    }
}
