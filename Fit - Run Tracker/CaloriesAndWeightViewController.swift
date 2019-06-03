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

    // MARK: - Global Variables
    private let secondsInDay: Double = 86400 //A global double constant that stores the number of seconds in a day
    private let healthStore = HKHealthStore() //A global HKHealthStore that is used to access the HealthKit data store

    private var currentDate = Date()
    private var currentWeight: Double = 0.0 //A global double variable that is used to store the current weight
    var caloriesBurnt: Double = 0.0 //A global double variable that is used to store the calories burnt
    var caloriesConsumed: Double = 0.0 //A global double variable that is used to store the calories consumed

    // MARK: - View Life Cycle

    /**
    This method is called by the system whenever the view will appear on screen. It configures the view to its initial state.
    1. Calls the function setDateLabel
    2. calls the function requestAuthorisationForHealthKitAccess
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        setDateLabel() //1
        requestAuthorisationForHealthKitAccess() //2
    }

    // MARK: - Interface Updates

    /**
    This method is called if weight data is retrieved successfully. It adds a weight progress bar to the interface.
    1. Clear any existing weight progress bar
    2. Create the frame for the progress bar (the same frame as the weight progress bar view but starting at the origin)
    3. Retrieve the goal weight from NSUserDefaults
    4. Create the weight progress bar
    5. Add the weight progress bar as a subview of the weightProgressBarView
    
    Uses the following local variables:
        view - The current UIView in the weightProgressBarView's subviews
        frame - A constant CGRect to use as the frame for the progress bar
        goalWeight - A constant double that is the user's goal weight from the user defaults
        progressBar - The WeightProgressBar that is to display on the interface
    */
    func addWeightProgressBar() {
        for view in weightProgressBarView.subviews as [UIView] { //1
            view.removeFromSuperview()
        }

        let frame = CGRect(x: 0, y: 0, width: self.weightProgressBarView.frame.width, height: self.weightProgressBarView.frame.height) //2

        let goalWeight = UserDefaults.standard.double(forKey: Constants.DefaultsKeys.Weight.GoalKey) //3

        let progressBar = WeightProgressBar(currentWeight: CGFloat(currentWeight), goalWeight: CGFloat(goalWeight), frame: frame) //4
        self.weightProgressBarView.addSubview(progressBar) //5
    }

    /**
    This method hides the weight progress and sets the error label to a given message.
    1. Hides the weight history button
    2. Shows the weight error label
    3. Sets the text of the weight error label to the message
    
    :param: message The string to display as the reason weight progress could not be displayed.
    */
    func hideWeightProgress(message: String) {
        self.weightHistoryButton.isHidden = true //1
        weightErrorLabel.isHidden = false //2
        weightErrorLabel.text = message //3
    }

    /**
    This method is called if the calorie data is retrieved successfully. It adds a calorie progress bar to the UI.
    1. Clear any existing calorie progress bars
    2. IF there is some calorie data (i.e. one of calories burnt or calories consumed are more than 0)
        a. Create the frame for the progress bar (the same frame as the calorie progress bar view but starting at the origin)
        b. Calculate the net calories (the calories consumed - the calories burnt)
        c. Retrieve the calorie goal from the NSUserDefaults
        d. Calculate the progress as the netCalories divide the calorieGoal
        e. Create the progress bar
        f. Add the progress bar as a subview of the calorieProgressBarView
        g. Set the calorie summary label to "NETCALORIES calories used of CALORIEGOAL" both rounded to the nearest whole number
        h. Set the calorie burnt label to "CALOIRESBURNT calories burnt" rounded to the nearest whole number
        i. Set the calories eaten label to "CALORIESCONSUMED calories consumed" rounded to the nearest whole number
    3. ELSE
        j. Sets the calorie summary label to "No calorie data."
    
    Uses the following local variables:
        view - The current UIView in the caloriesProgressBarView subviews
        frame - A constant CGRect that is the frame to use for the progress bar
        netCalories - A constant double that is the user's net calories (consumed calories - calories burnt in activities).
        calorieGoal - A constant double that is the user's calorie goal from the user defaults
        progress - A constant double that is the progress towards the calorie goal
        progressBar - The ProgressBar to display on the interface
    */
    func addCalorieProgressBar() {
        for view in caloriesProgressBarView.subviews as [UIView] { //1
            view.removeFromSuperview()
        }
        if caloriesBurnt > 0 || caloriesConsumed > 0 { //2
            let frame = CGRect(x: 0, y: 0, width: caloriesProgressBarView.frame.width, height: caloriesProgressBarView.frame.height) //a

            let netCalories = caloriesConsumed - caloriesBurnt //b
            let calorieGoal = UserDefaults.standard.double(forKey: Constants.DefaultsKeys.Calories.GoalKey) //c

            let progress: Double = netCalories / calorieGoal //d

            let progressBar = ProgressBar(progress: CGFloat(progress), frame: frame) //e
            self.caloriesProgressBarView.addSubview(progressBar) //f

            calorieSummaryLabel.text = NSString(format: "%1.0f calories used of %1.0f", netCalories, calorieGoal) as String //g
            burntCaloriesLabel.text = NSString(format: "%1.0f calories burnt", caloriesBurnt) as String //h
            eatenCaloriesLabel.text = NSString(format: "%1.0f calories consumed", caloriesConsumed) as String //i
        } else { //3
            calorieSummaryLabel.text = "No calorie data." //j
        }
    }

    /**
    This method is called to set the date label in the navigation bar
    1. IF the currentDate is today
        a. Set the label to "Today"
        b. Hide the next day button
    2. IF the currentDate is yesterday
        c. Set the label to "Yesterday"
    3. ELSE set the label to the current date as a short date string
    */
    func setDateLabel() {
        if currentDate.isToday { //1
            self.navigationItem.prompt = "Today" //a
            nextDayButton.title = "" //b
        } else if currentDate.isYesterday { //2
            self.navigationItem.prompt = "Yesterday" //c
        } else { //3
            self.navigationItem.prompt = currentDate.asShortDateString
        }
    }

    // MARK: - HealthKit Data Loading

    /**
    This method is called once HealthKit access is authorised. It loads the weight data from healthkit.
    1. Declare the unit to retrieve the weight in
    2. Declares the weightQuantity
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
           iv. Retrieve the main thread and call the function hideWeightProgress
    
    Uses the following local variables:
        weightUnit - A constant HKUnit that is the unit to retrieve the weight data in
        weightQuantity - A constant HKQuantityType that is the quantity to retrieve from the health kit datastore (body mass)
        startDate - A constant NSDate that is the startDate to look for samples, this is the distant past
        endDate - A constant NSDate that is the endDate to retrieve for samples, this is the very end of the current day
        predicate - A constant NSPredicate to filter the query using
    
        doubleWeight - This is used by the block; it is a double constant that stores the user's weight as a double (converted from a HKQuantitySample)
    */
    func loadWeightDataFromHealthKit() {
        let weightUnit = HKUnit(from: .kilogram) //1

        let weightQuantity = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) //2

        let startDate = Date.distantPast
        let endDate = currentDate.endOfDay()

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: []) //5

        self.healthStore.retrieveMostRecentSample(sampleType: weightQuantity!, predicate: predicate) { (currentWeight, error) -> Void in //6
            /* BLOCK A START */ //7
            if error != nil { //a
                DispatchQueue.main.async {  //i
                    self.hideWeightProgress(message: "Unable to get weight data.")
                    print("Error Reading From HealthKit Datastore: \(error!.localizedDescription)")
                }
            }

            if let weight = currentWeight as? HKQuantitySample { //b
                let doubleWeight = weight.quantity.doubleValue(for: weightUnit) //ii

                DispatchQueue.main.async {
                    self.currentWeight = doubleWeight
                    self.addWeightProgressBar()
                }
            } else { //c
                DispatchQueue.main.async {
                    self.hideWeightProgress(message: "No weight data.")
                }
            }
            /* BLOCK A END */
        }
    }

    /**
    This method is called once HealthKit access has been authorised. It loads the calorie data from HealthKit.
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
    
    Uses the following local variables:
        unit - A constant HKUnit that is the unit to retrieve the calorie data in
        caloriesBurnt - A constant HKQuantityType that is the quantity to query the datastore for (active energy burned)
        caloriesConsumed - A constant HKQuantityType that is the quantity to query the datastore for (dietary energy consumed)
        predicate - A constant NSPredicate used to filter the results of the query
    */
    func loadCalorieDataFromHealthKit() {
        let unit = HKUnit(from: .kilocalorie) //1
        let caloriesBurnt = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) //2
        let caloriesConsumed = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) //3

        let startOfCurrentDate = currentDate.startOfDay()
        let endOfCurrentDate = currentDate.endOfDay()
        let predicate = HKQuery.predicateForSamples(withStart: startOfCurrentDate, end: endOfCurrentDate, options: []) //4

        self.healthStore.retrieveSumOfSample(quantityType: caloriesConsumed!, unit: unit, predicate: predicate) { (sum, error) -> Void in //5
            /* BLOCK A START */ //6
            if error != nil { //a
                print("Error retrieving calorie consumed sum: " + error!.localizedDescription) //i

                DispatchQueue.main.async {
                    self.calorieSummaryLabel.text = "Unable to get calorie data."
                    self.burntCaloriesLabel.isHidden = true
                    self.eatenCaloriesLabel.isHidden = true
                }

                return //iii
            }

            DispatchQueue.main.async {
                /* BLOCK B START */
                self.caloriesConsumed = sum! //iv

                self.healthStore.retrieveSumOfSample(quantityType: caloriesBurnt!, unit: unit, predicate: predicate) { (sum, error) -> Void in //v
                    /* BLOCK C START */ //vi
                    if error != nil { //Z
                        print("Error retrieving calorie burnt sum: " + error!.localizedDescription)
                    }

                    DispatchQueue.main.async { //Y
                        self.caloriesBurnt = sum!
                        self.addCalorieProgressBar()
                    }
                    /* BLOCK C END */
                }

                /* BLOCK B END */
            }
            /* BLOCK A END */
        }
    }

    /**
    This method is called to requestAuthorisation to access a user's HealthKit datastore. IF a user has not already stated a preference a view controlled by the system will appear prompting a user to respond.
    1. Delcares the data types to READ from the HealthKit datastore
    2. Call the function requestAuthorizationToShareTypes passing an empty NSSet for WRITE types (we don't want to do any writing), and the 3 read types declared as an NSSet
    3. Once the request has been performed run the following block
        a. IF not successful
            i. Log "Authorising HealthKit access unsuccessful. Error: " and the error
           ii. Retrieve the main thread and call the function hideUIForNoAccess
        b. ELSE
          iii. Log "Success: HealthKit access is authorised."
           iv. Retrieve the main thread and call the function loadWeightDataFromHealthKit and loadCalorieDateFromHealthKit
    
    Uses the following local variables:
        caloriesBurnt - A constant HKQuantityType that is to be requested permission to read
        caloriesConsumed - A constant HKQuantityType that is to be requested permission to read
        weight - A constant HKQuantityType that is to be requested permission to read
    */
    func requestAuthorisationForHealthKitAccess() {
        let caloriesConsumed = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) //1
        let caloriesBurnt = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let weight = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)

        var readTypes = Set<HKObjectType>()
        readTypes.insert(caloriesBurnt!)
        readTypes.insert(caloriesConsumed!)
        readTypes.insert(weight!)

        self.healthStore.requestAuthorization(toShare: Set<HKSampleType>(), read: readTypes) { (success, error) in
            if !success { //a
                print("Authorising HealthKit access unsuccessful. Error: " + error.debugDescription) //i
                DispatchQueue.main.async {
                    /* BLOCK D START */
                    self.hideUIForNoAccess()
                    /* BLOCK D END */
                }
            } else { //b
                print("Success: HealthKit access is authorised.") //iii
                DispatchQueue.main.async {
                    /* BLOCK D START */
                    self.loadWeightDataFromHealthKit()
                    self.loadCalorieDataFromHealthKit()
                    /* BLOCK D END */
                }
            }
        }
    }

    /**
    This method is used to hide the user interface elements if HealthKit access is not authorised.
    1. Create and configure a label to display the error "HealthKit access must be enabled to use this feature."
    2. Remove the left bar button and set the navigation prompt to nil
    3. Set the view to the UILabel (removes anything else)
    
    Uses the following local variables:
        noAccessLabel - The UILabel to display if there is no access to HealthKit
    */
    func hideUIForNoAccess() {
        let noAccessLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.window!.frame.width, height: self.view.window!.frame.height)) //1
        noAccessLabel.text = "HealthKit access must be enabled to use this feature."
        noAccessLabel.textColor = UIColor.black
        noAccessLabel.backgroundColor = UIColor.white
        noAccessLabel.numberOfLines = 0
        noAccessLabel.font = UIFont(name: "System", size: 16)
        noAccessLabel.textAlignment = .center
        noAccessLabel.sizeToFit()

        self.navigationItem.leftBarButtonItem = .none //2
        self.navigationItem.prompt = nil

        self.view = noAccessLabel //3
    }

    // MARK: - Interface Actions

    /**
    This method is called by the system when the user presses the Next Day button on the interface. It moves the view forward one day.
    1. Sets the current date to be the old currentDate increased by 1 day
    2. Calls the function setDateLabel
    3. Calls the function loadWeightDataFromHealthKit
    4. Calls the function loadCalorieDateFromHealthKit
    
    :param: sender The object that called the action (in this case the Next button).
    */
    @IBAction func nextButtonPress(sender: AnyObject) {
        currentDate = currentDate.add(1.days)
        setDateLabel() //2
        loadWeightDataFromHealthKit() //3
        loadCalorieDataFromHealthKit() //4
    }

    /**
    This method is called by the system when the user presses the Previous Day button on the interface. It moves the view backwards 1 day.
    1. Sets the text of the nextDayButton to "Next Day" (this shows the button)
    2. Sets the current date to be the old currentDate decreased by 1 day
    3. Calls the function setDateLabel
    4. Calls the function loadWeightDataFromHealthKit
    5. Calls the function loadCalorieDateFromHealthKit
    
    :param: sender The object that called the action (in this case the Previous button).
    */
    @IBAction func previousDayPress(sender: AnyObject) {
        nextDayButton.title = "Next Day" //1
        currentDate = currentDate.subtract(1.days)
        setDateLabel() //3
        loadWeightDataFromHealthKit() //4
        loadCalorieDataFromHealthKit() //5
    }
}
