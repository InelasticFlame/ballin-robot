//
//  SetupViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 21/01/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    //MARK: - Storyboard Links
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var distanceSegment: UISegmentedControl!
    @IBOutlet weak var paceSegment: UISegmentedControl!
    @IBOutlet weak var weightSegment: UISegmentedControl!
    @IBOutlet weak var calorieStepper: UIStepper!
    @IBOutlet weak var calorieStepperLabel: UILabel!
    @IBOutlet weak var weightStepper: UIStepper!
    @IBOutlet weak var weightStepperLabel: UILabel!
    @IBOutlet weak var goalDistanceStepper: UIStepper!
    @IBOutlet weak var goalDistanceStepperLabel: UILabel!
    @IBOutlet weak var stravaAuthorisedLabel: UILabel!
    
    //MARK: - Global Variables
    
    private var changesMade = true //A global boolean variable that tracks whether the user has made any changes to settings; used to know whether to prompt a save or not

    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.DefaultsKeys.InitialSetup.SetupKey) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            if userDefaults.stringForKey("ACCESS_TOKEN")?.utf16Count > 0 {
                updateStravaLabel()
            }
            
            /* DISTANCE */
            let distanceUnit = userDefaults.stringForKey(Constants.DefaultsKeys.Distance.UnitKey)
            let distanceGoal = userDefaults.doubleForKey(Constants.DefaultsKeys.Distance.GoalKey)
            if distanceUnit == "kilometres" {
                distanceSegment.selectedSegmentIndex = 1
                goalDistanceStepper.value = distanceGoal * Conversions().milesToKm
            } else {
                goalDistanceStepper.value = distanceGoal
            }
            updateGoalDistanceLabel()
            
            /* PACE */
            let paceUnit = userDefaults.stringForKey(Constants.DefaultsKeys.Pace.UnitKey)
            if paceUnit == "km/h" {
                paceSegment.selectedSegmentIndex = 1
            }
            
            /* WEIGHT */
            let weightUnit = userDefaults.stringForKey(Constants.DefaultsKeys.Weight.UnitKey)
            let weightGoal = userDefaults.doubleForKey(Constants.DefaultsKeys.Weight.GoalKey)
            if weightUnit == "pounds" {
                weightSegment.selectedSegmentIndex = 1
                weightStepper.value = weightGoal * Conversions().kgToPounds
            } else {
                weightStepper.value = weightGoal
            }
            updateWeightGoalLabel()
            
            let calorieGoal = userDefaults.integerForKey(Constants.DefaultsKeys.Calories.GoalKey)
            calorieStepper.value = Double(calorieGoal)
            updateCalorieGoalLabel()
            
            changesMade = false
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStravaLabel", name: "AuthorisedSuccessfully", object: nil)
        calorieStepperLabel.text = "\(Int(calorieStepper.value))"
        weightStepperLabel.text = "\(Int(weightStepper.value)) kg"
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if changesMade {
            let alert = UIAlertController(title: "Save Settings?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { action in
                self.saveSettings()
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func saveSettings() {
        if distanceSegment.selectedSegmentIndex == 0 {
            NSUserDefaults.standardUserDefaults().setObject("miles", forKey: Constants.DefaultsKeys.Distance.UnitKey)
            NSUserDefaults.standardUserDefaults().setDouble(goalDistanceStepper.value, forKey: Constants.DefaultsKeys.Distance.GoalKey)
        } else {
            NSUserDefaults.standardUserDefaults().setObject("kilometres", forKey: Constants.DefaultsKeys.Distance.UnitKey)
            NSUserDefaults.standardUserDefaults().setDouble(Conversions().milesToKm * goalDistanceStepper.value, forKey: Constants.DefaultsKeys.Distance.GoalKey)
        }
        
        if paceSegment.selectedSegmentIndex == 0 {
            NSUserDefaults.standardUserDefaults().setObject("min/mile", forKey: Constants.DefaultsKeys.Pace.UnitKey)
        } else {
            NSUserDefaults.standardUserDefaults().setObject("km/h", forKey: Constants.DefaultsKeys.Pace.UnitKey)
        }
        
        if weightSegment.selectedSegmentIndex == 0 {
            NSUserDefaults.standardUserDefaults().setObject("kg", forKey: Constants.DefaultsKeys.Weight.UnitKey)
            NSUserDefaults.standardUserDefaults().setDouble(weightStepper.value, forKey: Constants.DefaultsKeys.Weight.GoalKey)
        } else {
            NSUserDefaults.standardUserDefaults().setObject("pounds", forKey: Constants.DefaultsKeys.Weight.UnitKey)
            NSUserDefaults.standardUserDefaults().setDouble(weightStepper.value * Conversions().poundsToKg, forKey: Constants.DefaultsKeys.Weight.GoalKey)
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(Int(calorieStepper.value), forKey: Constants.DefaultsKeys.Calories.GoalKey)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.DefaultsKeys.InitialSetup.SetupKey)

    }
    
    //MARK: - Interface Actions
    
    @IBAction func stravaConnectButtonPressed(sender: AnyObject) {
        StravaAuth().authoriseNewAccount()
    }

    @IBAction func distanceSegmentValueChanged(sender: UISegmentedControl) {
        changesMade = true
        updateGoalDistanceLabel()
    }
    
    @IBAction func weightSegmentValueChanged(sender: UISegmentedControl) {
        changesMade = true
        updateWeightGoalLabel()
    }
    
    @IBAction func calorieStepperValueChanged(sender: UIStepper) {
        changesMade = true
        updateCalorieGoalLabel()
    }
    
    /**
    This method changes the text of the weight goal label to the new value of the goal weight stepper, in either kilograms or pounds based on which setting is currently selected.
    */
    @IBAction func weightStepperValueChanged(sender: UIStepper) {
        changesMade = true
        updateWeightGoalLabel()
    }
    
    /** 
    This method changes the text of the goal distance label to the new value of the goal distance stepper, in either kilometres or miles based on which setting is currently selected.
    */
    @IBAction func goalDistanceStepperValueChanged(sender: UIStepper) {
        changesMade = true
        updateGoalDistanceLabel()
    }
    
    
    func updateWeightGoalLabel() {
        if weightSegment.selectedSegmentIndex == 0 {
            weightStepperLabel.text = "\(Int(weightStepper.value)) kg"
        } else {
            weightStepperLabel.text = "\(Int(weightStepper.value)) lb"
        }
    }
    
    func updateGoalDistanceLabel() {
        if distanceSegment.selectedSegmentIndex == 0 {
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) mi"
        } else {
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) km"
        }
    }
    
    func updateCalorieGoalLabel() {
        calorieStepperLabel.text = "\(Int(calorieStepper.value)) kCal"
    }
    
    func updateStravaLabel() {
        stravaAuthorisedLabel.textColor = UIColor.greenColor()
        stravaAuthorisedLabel.text = "Authorised"
    }
}
