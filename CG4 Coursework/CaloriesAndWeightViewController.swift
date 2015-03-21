//
//  CaloriesAndWeightViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 01/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit
import HealthKit

class CaloriesAndWeightViewController: UIViewController {

    // MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var nextDayButton: UIBarButtonItem!
    @IBOutlet weak var previousDayButton: UIBarButtonItem!
    @IBOutlet weak var weightHistoryButton: UIButton!
    @IBOutlet weak var caloriesProgressBarView: UIView!
    @IBOutlet weak var weightProgressBarView: UIView!
    @IBOutlet weak var calorieSummaryLabel: UILabel!
    @IBOutlet weak var eatenCaloriesLabel: UILabel!
    @IBOutlet weak var burntCaloriesLabel: UILabel!
    @IBOutlet weak var weightErrorLabel: UILabel!
    
    //MARK: - Global Variables
    private let secondsInDay: Double = 86400 //A global double constant that stores the number of seconds in a day
    private let healthStore = HKHealthStore() //A global HKHealthStore that is used to access the HealthKit data store
    
    private var currentDate = NSDate() //A global NSDate variable that stores the current date of the view
    private var currentWeight: Double = 0.0 //A global double variable that is used to store the current weight
    private var caloriesBurnt: Double = 0.0 //A global double variable that is used to store the calories burnt
    private var caloriesConsumed: Double = 0.0 //A global double variable that is used to store the calories consumed
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system whenever the view will appear on screen.
    1. Sets the weightErrorLabel to be hidden
    2. Calls the function setDateLabel
    3. calls the function requestAuthorisationForHealthKitAccess
    */
    override func viewWillAppear(animated: Bool) {
        weightErrorLabel.hidden = true //1
        setDateLabel() //2
        requestAuthorisationForHealthKitAccess() //3
    }
    
    //MARK: - Interface Updates
    
    /**
    This method is called if weight data is retrieved successfully
    1. Clear any existing weight progress bar
    2. Create the frame for the progress bar (the same frame as the weight progress bar view but starting at the origin)
    3. Retrive the goal weight from NSUserDefaults
    4. Create the weight progress bar
    5. Add the weight progress bar as a subview of the weightProgressBarView
    */
    func addWeightProgressBar() {
        for view in weightProgressBarView.subviews as [UIView] { //1
            view.removeFromSuperview()
        }
        
        let frame = CGRect(x: 0, y: 0, width: self.weightProgressBarView.frame.width, height: self.weightProgressBarView.frame.height) //2
        
        let goalWeight = NSUserDefaults.standardUserDefaults().doubleForKey(Constants.DefaultsKeys.Weight.GoalKey) //3
        
        let progressBar = WeightProgressBar(currentWeight: CGFloat(currentWeight), goalWeight: CGFloat(goalWeight), frame: frame) //4
        self.weightProgressBarView.addSubview(progressBar) //5
    }

    /**
    This method hides the weight progress and sets the error label to a given message.
    1. Hides the weight history button
    2. Shows the weight error label
    3. Sets the text of the weight error label to the message
    */
    func hideWeightProgress(message: String) {
        self.weightHistoryButton.hidden = true //1
        weightErrorLabel.hidden = false //2
        weightErrorLabel.text = message //3
    }
    
    /**
    This method is called if the calorie data is retrieved successfully.
    1. Clear any existing calorie progress bars
    2. Create the frame for the progress bar (the same frame as the calorie progress bar view but starting at the origin)
    3. Calculate the net calories (the calories consumed - the calories burnt)
    4. Retrieve the calore goal from the NSUserDefaults
    5. Calculate the progress as the netCalories divide the calorieGoal
    6. Create the progress bar
    7. Add the progress bar as a subview of the calorieProgressBarView
    8. Set the calorie summary label to "NETCALORIES calories used of CALORIEGOAL" both rounded to the nearest whole number
    9. Set the calorie burnt label to "CALOIRESBURNT calories burnt" rounded to the nearest whole number
   10. Set the calories eaten label to "CALORIESCONSUMED calories consumbed" rounded to the nearest whole number
    */
    func addCalorieProgressBar() {
        for view in caloriesProgressBarView.subviews as [UIView] { //1
            view.removeFromSuperview()
        }
        
        let frame = CGRect(x: 0, y: 0, width: caloriesProgressBarView.frame.width, height: caloriesProgressBarView.frame.height) //2
        
        let netCalories = caloriesConsumed - caloriesBurnt //3
        let calorieGoal = NSUserDefaults.standardUserDefaults().doubleForKey(Constants.DefaultsKeys.Calories.GoalKey) //4
        
        let progress: Double = netCalories / calorieGoal //5
        
        let progressBar = ProgressBar(progress: CGFloat(progress), frame: frame) //6
        self.caloriesProgressBarView.addSubview(progressBar) //7
        
        calorieSummaryLabel.text = NSString(format: "%1.0f calories used of %1.0f", netCalories, calorieGoal) //8
        burntCaloriesLabel.text = NSString(format: "%1.0f calories burnt", caloriesBurnt) //9
        eatenCaloriesLabel.text = NSString(format: "%1.0f calories consumed", caloriesConsumed) //10
    }
    
    /**
    This method is called to set the date label in the navigation bar
    1. IF the currentDate is today
        a. Set the label to "Today"
        b. Hide the next day button
    2. IF the currentDate is yesterday
        c. Set the label to "Yesterday"
    3. ELSE set th label to the current date as a short date string
    */
    func setDateLabel() {
        if currentDate.isToday() { //1
            self.navigationItem.prompt = "Today" //a
            nextDayButton.title = "" //b
        } else if currentDate.isYesterday() { //2
            self.navigationItem.prompt = "Yesterday" //c
        } else { //3
            self.navigationItem.prompt = currentDate.shortDateString()
        }
    }
    
    //MARK: - HealthKit Data Loading
    
    /**
    This method is called once HealthKit access is authorised.
    1. Declare the unit to retrieve the weight in
    2. Decalres the weightQuantity
    3. Declares the start date as the distant past (IF there is any weight data it will be retrieved)
    4. Declares the end date as the very end of the currentDay
    5. Create a predicate to retrieve the samples between the start and end date
    6. Calls the function retrieveMostRecentSample passing the weight quantity and the predicate
    7. On completion performs the BLOCK A
        a. IF there is an error
            i. Retrieve the main thread (HealthKit read/writes are performed on their own thread -> UI updates should be performed on the main thread) and call the function hideWeightProgress and log the error
        b. IF there is a weight
           ii. Retrieve the double value of the weight for the weightUnit (kilograms)
          iii. Retrieve the main thread and set the currentWeight to the double weight and call the function addWeightProgressBar
        c. ELSE
           iv. Retrive the main thread and call the function hideWeightProgress
    */
    func loadWeightDataFromHealthKit() {
        var weightUnit = HKUnit(fromMassFormatterUnit: .Kilogram) //1
        
        let weightQuantity = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass) //2
        
        var startDate = NSDate.distantPast() as NSDate //3
        var endDate = NSDate(timeInterval: secondsInDay - 1, sinceDate: NSDate(shortDateString: self.currentDate.shortDateString())) //4
        //The 'end date' that is the very end of the day of the start date
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: nil) //5
        
        self.healthStore.retrieveMostRecentSample(weightQuantity, predicate: predicate) { (currentWeight, error) -> Void in //6
            /* BLOCK A START */ //7
            if error != nil { //a
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //i
                    self.hideWeightProgress("Unable to get weight data.")
                    println("Error Reading From HealthKit Datastore: \(error.localizedDescription)")
                })
            }
            
            if let weight = currentWeight as? HKQuantitySample { //b
                let doubleWeight = weight.quantity.doubleValueForUnit(weightUnit) //ii
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //iii
                    self.currentWeight = doubleWeight
                    self.addWeightProgressBar()
                })
            } else { //c
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //iv
                    self.hideWeightProgress("No weight data.")
                })
            }
            /* BLOCK A END */
        }
    }
    
    /**
    This method is called once HealthKit access has been authorised.
    1. Declare the unit to retrieve calories from the HealthKit datastore in
    2. Declares the caloriesBurnt quantity
    3. Declares the caloriesConsumed quantity
    4. Create a predicate to retrieve samples for the current day
    5. Call the function retrieveSumOfSample passing the caloriesConsumed quantity, the unit and the predicate
    6. Once complete runs BLOCK A
        a. IF there is an error
            i. Log the error
           ii. Retrieve the main thread and setup the interface for no calorie data
          iii. Skip the rest of the block
        b. Get the main thread (HealthKit read/writes are performed on their own thread -> UI updates should be performed on the main thread) and perform BLOCK B
           iv. Set the caloriesConsumed to the sum returned
            v. Call the function retrieveSumOfSmple passing the caloriesBurnt quantity, the unit and the predicate
           vi. Once complete perform BLOCK C
                Z. IF there is an error log it
                Y. Retrieve the main thread and set the caloriesBurnt to the sum retrieved and call the function addCalorieProgressBar
    */
    func loadCalorieDataFromHealthKit() {
        let unit = HKUnit(fromEnergyFormatterUnit: .Kilocalorie) //1
        let caloriesBurnt = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned) //2
        let caloriesConsumed = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed) //3
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate(shortDateString: self.currentDate.shortDateString()), endDate: NSDate(timeInterval: 86399, sinceDate: NSDate(shortDateString: self.currentDate.shortDateString())), options: nil) //4
        
        self.healthStore.retrieveSumOfSample(caloriesConsumed, unit: unit, predicate: predicate) { (sum, error) -> Void in //5
            /* BLOCK A START */ //6
            if error != nil { //a
                print("Error retrieving calorie consumed sum: " + error.localizedDescription) //i
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //ii
                    self.calorieSummaryLabel.text = "Unable to get calorie data."
                    self.burntCaloriesLabel.hidden = true
                    self.eatenCaloriesLabel.hidden = true
                })
                
                return //iii
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in //b
                /* BLOCK B START */
                self.caloriesConsumed = sum //iv
                
                self.healthStore.retrieveSumOfSample(caloriesBurnt, unit: unit, predicate: predicate) { (sum, error) -> Void in //v
                    /* BLOCK C START */ //vi
                    if error != nil { //Z
                        print("Error retrieving calorie burnt sum: " + error.localizedDescription)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in //Y
                        self.caloriesBurnt = sum
                        self.addCalorieProgressBar()
                    })
                    /* BLOCK C END */
                }
                
                /* BLOCK B END */
            })
            /* BLOCK A END */
        }
    }
    
    /**
    This method is called to requestAuthrisation to access a user's HealthKit datastore. IF a user has not already stated a preference a view controlled by the system will appear prompting a user to respond.
    1. Delcares the data types to READ from the HealthKit datastore
    2. Call the function requestAuthorizationToShareTypes passing an empty NSSet for WRITE types (we don't want to do any writing), and the 3 read types delcared as an NSSet
    3. Once the request has been performed run the following block
        a. IF not successful
            i. Log "Authorising HealthKit access unsuccessful. Error: " and the error
           ii. Retrieve the main thread and call the function hideUIForNoAccess
        b. ELSE
          iii. Log "Success: HealthKit access is authroised."
           iv. Retrieve the main thread and call the function loadWeightDataFromHealthKit and loadCalorieDateFromHealthKit
    */
    func requestAuthorisationForHealthKitAccess() {
        let caloriesConsumed = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed) //1
        let caloriesBurnt = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        let weight = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        self.healthStore.requestAuthorizationToShareTypes(NSSet(), readTypes: NSSet(array: [caloriesConsumed, caloriesBurnt, weight])) { (success: Bool, error: NSError!) -> Void in //2 //3
            /* BLOCK START */
            
            if !success { //a
                println("Authorising HealthKit access unsuccessful. Error: " + error.description) //i
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //ii
                    /* BLOCK D START */
                    self.hideUIForNoAccess()
                    /* BLOCK D END */
                })
            } else { //b
                println("Success: HealthKit access is authorised.") //iii
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //iv
                    /* BLOCK D START */
                    self.loadWeightDataFromHealthKit()
                    self.loadCalorieDataFromHealthKit()
                    /* BLOCK D END */
                })
            }
            /* BLOCK END */
        }
    }
    
    /**
    1. Create and configure a label to display the error "HealthKit access must be enabled to use this feature."
    2. Remove the left bar button and set the navigation prompt to nil
    3. Set the view to the UILabel (removes anything else)
    */
    func hideUIForNoAccess() {
        let noAccessLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.window!.frame.width, height: self.view.window!.frame.height)) //1
        noAccessLabel.text = "HealthKit access must be enabled to use this feature."
        noAccessLabel.textColor = UIColor.blackColor()
        noAccessLabel.backgroundColor = UIColor.whiteColor()
        noAccessLabel.numberOfLines = 0
        noAccessLabel.font = UIFont(name: "System", size: 16)
        noAccessLabel.textAlignment = .Center
        noAccessLabel.sizeToFit()
        
        self.navigationItem.leftBarButtonItem = .None //2
        self.navigationItem.prompt = nil
        
        self.view = noAccessLabel //3
    }

    //MARK: - Interface Actions
    
    /**
    This method is called by the system when the user presses the Next Day button on the interface
    1. Sets the current date to be the old currentDate increased by 1 day
    2. Calls the function setDateLabel
    3. Calls the function loadWeightDataFromHealthKit
    4. Calls the function loadCalorieDateFromHealthKit
    */
    @IBAction func nextButtonPress(sender: AnyObject) {
        currentDate = NSDate(timeInterval: secondsInDay, sinceDate: currentDate) //1
        setDateLabel() //2
        loadWeightDataFromHealthKit() //3
        loadCalorieDataFromHealthKit() //4
    }
    
    /**
    This method is called by the system when the user presses the Previous Day button on the interface
    1. Sets the text of the nextDayButton to "Next Day" (this shows the button)
    2. Sets the current date to be the old currentDate decreased by 1 day
    3. Calls the function setDateLabel
    4. Calls the function loadWeightDataFromHealthKit
    5. Calls the function loadCalorieDateFromHealthKit
    */
    @IBAction func previousDayPress(sender: AnyObject) {
        nextDayButton.title = "Next Day" //1
        currentDate = NSDate(timeInterval: -secondsInDay, sinceDate: currentDate) //2
        setDateLabel() //3
        loadWeightDataFromHealthKit() //4
        loadCalorieDataFromHealthKit() //5
    }
}
