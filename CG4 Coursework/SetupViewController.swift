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
    
    /**
    This method is called by the system when the view is initially loaded.
    1. IF setup has already been performed
        2. Declares the local constant userDefaults as a reference to the standardUserDefaults
        3. IF there is an ACCESS_TOKEN stored
            a. Calls the function updateStravaLabel
        4. Retrieves the distance unit storing it as a local string constant
        5. Retrieves the distance goal storing it as a local double constant
        6. IF the distance unit is the km unit
            b. Sets the selected segment of the distanceSegment to the second segment
            c. Sets the value of the goalDistanceStepper to the distanceGoal converted from miles to km
        7. ELSE
            d. Sets the goalDistanceStepper value to the distance goal
        8. Retrieves the pace unit and stores it as a local string constant
        9. IF the pace unit is km/h
            e. Sets the selected segment of the paceSegment to the second segment
       10. Retrieves the weight unit storing it as a local string constant
       11. Retrieves the weight goal storing it as a local double constant
       12. IF the weight unit is the pound unit
            f. Sets the selected segment of the weightSegment to the second segment
            g. Sets the value of the weight stepper to the weightGoal converted from kg to pounds
       13. ELSE
            h. Sets the value of the weight stepper to the weightGoal
       14. Retrieves the calorie goal and stores it as a local integer constant
       15. Set the value of the weight steppers as the calorie goal
       16. Sets changes made to false
    17. Tells the class to listen for the notification  AuthorisedSuccessfully and to call the function updateStravaLabel when it receives the notification
    18. Calls the function updateWeightGoalLabel
    19. Calls the function updateCalorieGoalLabel
    20. Calls the function updateGoalDistanceLabel
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.DefaultsKeys.InitialSetup.SetupKey) { //1
            let userDefaults = NSUserDefaults.standardUserDefaults() //2
            
            if userDefaults.stringForKey("ACCESS_TOKEN")?.utf16Count > 0 { //3
                updateStravaLabel() //a
            }
            
            /* DISTANCE */
            let distanceUnit = userDefaults.stringForKey(Constants.DefaultsKeys.Distance.UnitKey) //4
            let distanceGoal = userDefaults.doubleForKey(Constants.DefaultsKeys.Distance.GoalKey) //5
            if distanceUnit == Constants.DefaultsKeys.Distance.KmUnit { //6
                distanceSegment.selectedSegmentIndex = 1 //b
                goalDistanceStepper.value = distanceGoal * Conversions().milesToKm //c
            } else { //7
                goalDistanceStepper.value = distanceGoal //d
            }
            
            /* PACE */
            let paceUnit = userDefaults.stringForKey(Constants.DefaultsKeys.Pace.UnitKey) //8
            if paceUnit == Constants.DefaultsKeys.Pace.KMPerH { //9
                paceSegment.selectedSegmentIndex = 1 //e
            }
            
            /* WEIGHT */
            let weightUnit = userDefaults.stringForKey(Constants.DefaultsKeys.Weight.UnitKey) //10
            let weightGoal = userDefaults.doubleForKey(Constants.DefaultsKeys.Weight.GoalKey) //11
            if weightUnit == Constants.DefaultsKeys.Weight.PoundUnit { //12
                weightSegment.selectedSegmentIndex = 1 //f
                weightStepper.value = weightGoal * Conversions().kgToPounds //g
            } else { //13
                weightStepper.value = weightGoal //h
            }
            
            let calorieGoal = userDefaults.integerForKey(Constants.DefaultsKeys.Calories.GoalKey) //14
            calorieStepper.value = Double(calorieGoal) //15
            
            changesMade = false //16
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStravaLabel", name: "AuthorisedSuccessfully", object: nil) //17
        
        updateWeightGoalLabel() //18
        updateCalorieGoalLabel() //19
        updateGoalDistanceLabel() //20
    }
    
    //MARK: - Settings Saving
    /**
    This method is used to save a user's settings.
    1. Declares the local constant userDefaults as a reference to the standardUserDefaults
    2. IF the first segment is selected in the distanceSegment
        a. Saves the distance unit as the MilesUnit
        b. Saves the distance goal as the value of the goal distance stepper
    3. ELSE
        c. Saves the distance unit as the KmUnit
        d. Sets the distance goal as the value of the goal distance stepper converted from km to miles
    4. IF the first segment is selected in the paceSegment
        e. Saves the pace unit as the min per mile unit
    5. ELSE
        f. Save the pace unit as the km/h unit
    6. IF the first segment is selected in the weightSegment
        g. Sets the weight unit as the Kg unit
        h. Sets the weight goal as the value of the weight stepper
    7. ELSE
        i. Sets the weight unit as the pounds unit
        j. Sets the weight goal the value of the weight stepper converted from pounds to kg
    8. Sets the calorie goal as the value of the calorie stepper
    9. Sets the InitialSetup as being completed (true)
    10. Dismisses the setup view controller
    */
    func saveSettings() {
        let userDefaults = NSUserDefaults.standardUserDefaults() //1
        
        if distanceSegment.selectedSegmentIndex == 0 { //2
            //Miles
            userDefaults.setObject(Constants.DefaultsKeys.Distance.MilesUnit, forKey: Constants.DefaultsKeys.Distance.UnitKey) //a
            userDefaults.setDouble(goalDistanceStepper.value, forKey: Constants.DefaultsKeys.Distance.GoalKey) //b
        } else { //3
            //Kilometres
            userDefaults.setObject(Constants.DefaultsKeys.Distance.KmUnit, forKey: Constants.DefaultsKeys.Distance.UnitKey) //c
            userDefaults.setDouble(Conversions().kmToMiles * goalDistanceStepper.value, forKey: Constants.DefaultsKeys.Distance.GoalKey) //d
        }
        
        if paceSegment.selectedSegmentIndex == 0 { //4
            //min/mile
            userDefaults.setObject(Constants.DefaultsKeys.Pace.MinMileUnit, forKey: Constants.DefaultsKeys.Pace.UnitKey) //e
        } else { //5
            //km/h
            userDefaults.setObject(Constants.DefaultsKeys.Pace.KMPerH, forKey: Constants.DefaultsKeys.Pace.UnitKey) //f
        }
        
        if weightSegment.selectedSegmentIndex == 0 { //6
            //Kg
            userDefaults.setObject(Constants.DefaultsKeys.Weight.KgUnit, forKey: Constants.DefaultsKeys.Weight.UnitKey) //g
            userDefaults.setDouble(weightStepper.value, forKey: Constants.DefaultsKeys.Weight.GoalKey) //h
        } else { //7
            //Pounds
            userDefaults.setObject(Constants.DefaultsKeys.Weight.PoundUnit, forKey: Constants.DefaultsKeys.Weight.UnitKey) //i
            userDefaults.setDouble(weightStepper.value * Conversions().poundsToKg, forKey: Constants.DefaultsKeys.Weight.GoalKey) //j
        }
        
        userDefaults.setInteger(Int(calorieStepper.value), forKey: Constants.DefaultsKeys.Calories.GoalKey) //8
        
        userDefaults.setBool(true, forKey: Constants.DefaultsKeys.InitialSetup.SetupKey) //9
        self.dismissViewControllerAnimated(true, completion: nil) //10
    }
    
    //MARK: - Interface Actions
    
    /**
    This method is called when the user presses the done button
    1. IF changes have been made
        a. Create an alert with the title "Save Settings?" and the options 'Save' and 'Cancel'
        (Pressing save calls the function saveSettings and dismisses the view controller, pressing cancel just dismisses the view controller)
        b. Present the alert
    2. ELSE
        a. Dismiss the setupViewController
    */
    @IBAction func donePressed(sender: AnyObject) {
        if changesMade { //1
            let alert = UIAlertController(title: "Save Settings?", message: "", preferredStyle: UIAlertControllerStyle.Alert) //a
            alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { action in
                self.saveSettings()
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil) //b
        } else { //2
            self.dismissViewControllerAnimated(true, completion: nil) //a
        }
    }
    
    /**
    This method is called when the user presses the Connect With Strava button. It calls the function authoriseNewAccount from the StravaAuth class
    */
    @IBAction func stravaConnectButtonPressed(sender: AnyObject) {
        StravaAuth().authoriseNewAccount()
    }

    /**
    This method is called when the user changes the value of the distant segment. It sets the changesMade to true and calls the function updateGoalDistanceLabel
    */
    @IBAction func distanceSegmentValueChanged(sender: UISegmentedControl) {
        changesMade = true
        updateGoalDistanceLabel()
    }
    
    /**
    This method is called when the user changes the value of the weight segment. It sets the changesMade to true and calls the function updateWeightGoalLabel
    */
    @IBAction func weightSegmentValueChanged(sender: UISegmentedControl) {
        changesMade = true
        updateWeightGoalLabel()
    }
    
    /**
    This method is called when the user changes the value of the calorie stepper. It sets the changesMade to true and calls the function updateCalorieGoalLabel
    */
    @IBAction func calorieStepperValueChanged(sender: UIStepper) {
        changesMade = true
        updateCalorieGoalLabel()
    }
    
    /**
    This method is called when the user changes the value of the weight stepper. It sets the changesMade to true and calls the function updateWeightGoalLabel
    */
    @IBAction func weightStepperValueChanged(sender: UIStepper) {
        changesMade = true
        updateWeightGoalLabel()
    }
    
    /** 
    This method is called when the user changes the value of the goal distance stepper. It sets the changesMade to true and calls the function updateGoalDistanceLabel
    */
    @IBAction func goalDistanceStepperValueChanged(sender: UIStepper) {
        changesMade = true
        updateGoalDistanceLabel()
    }
    
    //MARK: - Label Updates
    
    /**
    This method updates the text of the weight goal label.
    1. IF the weightSegment selected is the first segment
        a. The weightStepperLabel text is the value of the weightStepper + kg
    2. ELSE
        b. The weightStepperLabel text is the value of the weightStepper + lb
    */
    func updateWeightGoalLabel() {
        if weightSegment.selectedSegmentIndex == 0 { //1
            weightStepperLabel.text = "\(Int(weightStepper.value)) kg" //a
        } else { //2
            weightStepperLabel.text = "\(Int(weightStepper.value)) lb" //b
        }
    }
    
    /**
    This method updates the text of the weight goal label.
    1. IF the distanceSegment selected is the first segment
        a. The goalDistanceStepperLabel text is the value of the goalDistanceStepper + mi
    2. ELSE
        b. The goalDistanceStepperLabel text is the value of the goalDistanceStepper + km
    */
    func updateGoalDistanceLabel() {
        if distanceSegment.selectedSegmentIndex == 0 { //1
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) mi" //a
        } else { //2
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) km" //b
        }
    }
    
    /**
    This method updates the text of the calorie goal label.
    */
    func updateCalorieGoalLabel() {
        calorieStepperLabel.text = "\(Int(calorieStepper.value))"
    }
    
    /**
    This method updates the StravaLabel when a user's account has been authorised. It sets the text colour to green and sets the text of the label to "Authorised"
    */
    func updateStravaLabel() {
        stravaAuthorisedLabel.textColor = UIColor.greenColor()
        stravaAuthorisedLabel.text = "Authorised"
    }
}
