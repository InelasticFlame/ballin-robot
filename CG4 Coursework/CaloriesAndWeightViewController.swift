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

    /* Storyboard Links */
    @IBOutlet weak var nextDayButton: UIBarButtonItem!
    @IBOutlet weak var previousDayButton: UIBarButtonItem!
    @IBOutlet weak var weightHistoryButton: UIButton!
    
    @IBOutlet weak var caloriesProgressBarView: UIView!
    @IBOutlet weak var weightProgressBarView: UIView!
    
    @IBOutlet weak var calorieSummaryLabel: UILabel!
    @IBOutlet weak var eatenCaloriesLabel: UILabel!
    @IBOutlet weak var burntCaloriesLabel: UILabel!
    
    private var currentDate = NSDate()
    private let secondsInDay: Double = 86400
    private var healthStore = HKHealthStore()
    private var currentWeight: Double = 0.0
    private var caloriesBurnt: Double = 0.0
    private var caloriesConsumed: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDateLabel()
        requestAuthorisationForHealthKitAccess()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func addWeightProgressBar() {
        //Clear any existing progress bar
        for view in weightProgressBarView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        let frame = CGRect(x: 0, y: 0, width: self.weightProgressBarView.frame.width, height: self.weightProgressBarView.frame.height)
        
        let goalWeight = NSUserDefaults.standardUserDefaults().doubleForKey(Constants.DefaultsKeys.Weight.GoalKey)
        
        let progressBar = WeightProgressBar(currentWeight: CGFloat(currentWeight), goalWeight: CGFloat(goalWeight), frame: frame)
        self.weightProgressBarView.addSubview(progressBar)
    }

    func addCalorieProgressBar() {
        for view in caloriesProgressBarView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        let frame = CGRect(x: 0, y: 0, width: caloriesProgressBarView.frame.width, height: caloriesProgressBarView.frame.height)
        
        let netCalories = caloriesConsumed - caloriesBurnt
        let calorieGoal = NSUserDefaults.standardUserDefaults().doubleForKey(Constants.DefaultsKeys.Calories.GoalKey)
        
        let progress: Double = netCalories / calorieGoal
        
        let progressBar = ProgressBar(progress: CGFloat(progress), frame: frame)
        self.caloriesProgressBarView.addSubview(progressBar)
        
        calorieSummaryLabel.text = NSString(format: "%1.0f calories used of %1.0f", netCalories, calorieGoal)
        burntCaloriesLabel.text = NSString(format: "%1.0f calories burnt", caloriesBurnt)
        eatenCaloriesLabel.text = NSString(format: "%1.0f calories consumed", caloriesConsumed)
    }
    
    func setDateLabel() {
        if currentDate.isToday() {
            self.navigationItem.prompt = "Today"
            nextDayButton.title = ""
        } else if currentDate.isYesterday() {
            self.navigationItem.prompt = "Yesterday"
        } else {
            self.navigationItem.prompt = currentDate.shortDateString()
        }
    }
    
    func loadWeightDataFromHealthKit() {
        var weightUnit = HKUnit(fromMassFormatterUnit: .Kilogram)
        
        let weightQuantity = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        var startDate = NSDate(shortDateString: self.currentDate.shortDateString()) //The date to retrieve from
        var endDate = NSDate(timeInterval: 86399, sinceDate: NSDate(shortDateString: self.currentDate.shortDateString())) //The 'end date' that is the very end of the day of the start date

        if self.navigationItem.prompt == "Today" { //The view is initially set for 'Today', in the event that there is no weight data for today, the most recent data from any point in time is loaded
            startDate = NSDate.distantPast() as NSDate
            endDate = NSDate.distantFuture() as NSDate
        }
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: nil)
        
        self.healthStore.retrieveMostRecentSample(weightQuantity, predicate: predicate) { (currentWeight, error) -> Void in
            /* BLOCK START */
            if (error != nil) {
                println("Error Reading From HealthKit Datastore: \(error.localizedDescription)")
            }
            
            if let weight = currentWeight as? HKQuantitySample {
                let doubleWeight = weight.quantity.doubleValueForUnit(weightUnit)
                
                //HealthKit read/writes are performed on their own thread -> UI updates should be performed on the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    /* BLOCK START */
                    self.currentWeight = doubleWeight
                    self.addWeightProgressBar()
                    /* BLOCK END */
                })
            }
            /* BLOCK END */
        }
    }
    
    func loadCalorieDataFromHealthKit() {
        let unit = HKUnit(fromEnergyFormatterUnit: .Kilocalorie)
        let caloriesBurnt = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        let caloriesConsumed = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate(shortDateString: self.currentDate.shortDateString()), endDate: NSDate(timeInterval: 86399, sinceDate: NSDate(shortDateString: self.currentDate.shortDateString())), options: nil)
        
        self.healthStore.retrieveSumOfSample(caloriesConsumed, unit: unit, predicate: predicate) { (sum, error) -> Void in
            /* BLOCK A START */
            if error != nil {
                print(error.localizedDescription)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                /* BLOCK B START */
                self.caloriesConsumed = sum
                println("Sum Consumed: \(sum)")
                
                self.healthStore.retrieveSumOfSample(caloriesBurnt, unit: unit, predicate: predicate) { (sum, error) -> Void in
                    /* BLOCK C START */
                    if error != nil {
                        print(error.localizedDescription)
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        /* BLOCK D START */
                        self.caloriesBurnt = sum
                        println("Sum Burnt: \(sum)")
                        self.addCalorieProgressBar()
                        /* BLOCK D END */
                    })
                    /* BLOCK C END */
                }
                
                /* BLOCK B END */
            })
            /* BLOCK A END */
        }
    }
    
    func requestAuthorisationForHealthKitAccess() {
        //Data types to READ
        let caloriesConsumed = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)
        let caloriesBurnt = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        let weight = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        self.healthStore.requestAuthorizationToShareTypes(NSSet(), readTypes: NSSet(array: [caloriesConsumed, caloriesBurnt, weight])) { (success: Bool, error: NSError!) -> Void in
            /* BLOCK START */
            
            if !success {
                println("Authorising HealthKit access unsuccessful. Error: " + error.description)
            } else {
                println("Success: HealthKit access is authorised")
                self.loadWeightDataFromHealthKit()
                self.loadCalorieDataFromHealthKit()
            }
            /* BLOCK END */
        }
    }

    @IBAction func nextButtonPress(sender: AnyObject) {
        currentDate = NSDate(timeInterval: secondsInDay, sinceDate: currentDate)
        setDateLabel()
        loadWeightDataFromHealthKit()
        loadCalorieDataFromHealthKit()
    }
    
    @IBAction func previousDayPress(sender: AnyObject) {
        nextDayButton.title = "Next Day"
        currentDate = NSDate(timeInterval: -secondsInDay, sinceDate: currentDate)
        setDateLabel()
        loadWeightDataFromHealthKit()
        loadCalorieDataFromHealthKit()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
