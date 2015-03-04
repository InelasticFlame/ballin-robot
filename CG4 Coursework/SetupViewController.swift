//
//  SetupViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 21/01/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    @IBOutlet weak var distanceSegment: UISegmentedControl!
    @IBOutlet weak var paceSegment: UISegmentedControl!
    @IBOutlet weak var weightSegment: UISegmentedControl!
    @IBOutlet weak var calorieStepper: UIStepper!
    @IBOutlet weak var calorieStepperLabel: UILabel!
    @IBOutlet weak var weightStepper: UIStepper!
    @IBOutlet weak var weightStepperLabel: UILabel!
    @IBOutlet weak var goalDistanceStepper: UIStepper!
    @IBOutlet weak var goalDistanceStepperLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load view with current settings
        
        calorieStepperLabel.text = "\(Int(calorieStepper.value))"
        weightStepperLabel.text = "\(Int(weightStepper.value)) kg"
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Save Settings?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { action in
            self.saveSettings()
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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

    @IBAction func distanceSegmentValueChanged(sender: UISegmentedControl) {
        if distanceSegment.selectedSegmentIndex == 0 {
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) mi"
        } else {
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) km"
        }
    }
    
    @IBAction func weightSegmentValueChanged(sender: UISegmentedControl) {
        if weightSegment.selectedSegmentIndex == 0 {
            weightStepperLabel.text = "\(Int(weightStepper.value)) kg"
        } else {
            weightStepperLabel.text = "\(Int(weightStepper.value)) lb"
        }
    }
    
    @IBAction func calorieStepperValueChanged(sender: UIStepper) {
        calorieStepperLabel.text = "\(Int(calorieStepper.value))"
    }
    
    /**
    This method changes the text of the weight goal label to the new value of the goal weight stepper, in either kilograms or pounds based on which setting is currently selected.
    */
    @IBAction func weightStepperValueChanged(sender: UIStepper) {
        if weightSegment.selectedSegmentIndex == 0 {
            weightStepperLabel.text = "\(Int(weightStepper.value)) kg"
        } else {
            weightStepperLabel.text = "\(Int(weightStepper.value)) lb"
        }
    }
    
    /** 
    This method changes the text of the goal distance label to the new value of the goal distance stepper, in either kilometres or miles based on which setting is currently selected.
    */
    @IBAction func goalDistanceStepperValueChanged(sender: UIStepper) {
        if distanceSegment.selectedSegmentIndex == 0 {
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) mi"
        } else {
            goalDistanceStepperLabel.text = "\(Int(goalDistanceStepper.value)) km"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
