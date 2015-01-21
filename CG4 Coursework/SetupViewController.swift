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
        // Do any additional setup after loading the view.
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
            NSUserDefaults.standardUserDefaults().setObject("miles", forKey: "distanceUnit")
            NSUserDefaults.standardUserDefaults().setDouble(goalDistanceStepper.value, forKey: "goalDistance")
        } else {
            NSUserDefaults.standardUserDefaults().setObject("kilometres", forKey: "distanceUnit")
            NSUserDefaults.standardUserDefaults().setDouble(Conversions().milesToKm * goalDistanceStepper.value, forKey: "goalDistance")
        }
        
        if paceSegment.selectedSegmentIndex == 0 {
            NSUserDefaults.standardUserDefaults().setObject("min/mile", forKey: "paceUnit")
        } else {
            NSUserDefaults.standardUserDefaults().setObject("km/h", forKey: "paceUnit")
        }
        
        if weightSegment.selectedSegmentIndex == 0 {
            NSUserDefaults.standardUserDefaults().setObject("kg", forKey: "weightUnit")
        } else {
            NSUserDefaults.standardUserDefaults().setObject("pounds", forKey: "weightUnit")
        }
        
        NSUserDefaults.standardUserDefaults().setDouble(weightStepper.value, forKey: "weightGoal")
        NSUserDefaults.standardUserDefaults().setInteger(Int(calorieStepper.value), forKey: "calorieGoal")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "initialSetupPerformed")

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
    
    @IBAction func weightStepperValueChanged(sender: UIStepper) {
        if weightSegment.selectedSegmentIndex == 0 {
            weightStepperLabel.text = "\(Int(weightStepper.value)) kg"
        } else {
            weightStepperLabel.text = "\(Int(weightStepper.value)) lb"
        }
    }
    
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
