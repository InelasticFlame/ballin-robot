//
//  NewPlannedRunTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class NewPlannedRunTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Storyboard Links
    @IBOutlet weak var distanceDurationSegement: UISegmentedControl!
    @IBOutlet weak var plannedRunDate: UIDatePicker!
    @IBOutlet weak var plannedDistancePicker: DistancePicker!
    @IBOutlet weak var plannedDurationPicker: DurationPicker!
    @IBOutlet weak var runDateDetailLabel: UILabel!
    @IBOutlet weak var runDistanceDurationDetailLabel: UILabel!
    @IBOutlet weak var runDetailsTextField: UITextField!
    
    // MARK: - Global Variables
    private var editingRunDate = false
    private var editingRunDistanceDuration = false
    private var showRepeat = false
    private let secondsInDay: Double = 86400
    var plan: Plan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plannedRunDate.minimumDate = plan?.startDate //Prevents a user from planning a run before the plan begins
        plannedRunDate.maximumDate = plan?.endDate //Prevents a user from planning a run after the plan ends
        
        runDateDetailLabel.text = plannedRunDate.date.shortDateString()
        updateDetailLabels()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDetailLabels", name: "UpdateDetailLabel", object: nil)
    }

    @IBAction func distanceDurationSegmentValueChanged(sender: UISegmentedControl) {
        reloadTableViewCells()
        updateDetailLabels()
    }
    
    func updateDetailLabels() {
        if distanceDurationSegement.selectedSegmentIndex == 0 {
            runDistanceDurationDetailLabel.text = plannedDistancePicker.selectedDistance().distanceStr
        } else if distanceDurationSegement.selectedSegmentIndex == 1 {
            runDistanceDurationDetailLabel.text = plannedDurationPicker.selectedDuration().durationStr
        }
    }
    
    //MARK: - Text Field
    
    /**
    This method is called by the system when a user presses the return button on the keyboard whilst inputting into the text field.
    1. Dismisses the keyboard by removing the textField as the first responder for the view (the focus)
    2. Returns false
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() //1
        
        return false //2
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7 {
            return 44
            
        } else if indexPath.row == 8 && showRepeat {
            return 44
        } else {
            if indexPath.row == 1 && editingRunDate {
                return 162
            }
            
            if editingRunDistanceDuration {
                if distanceDurationSegement.selectedSegmentIndex == 0 && indexPath.row == 3 {
                    return 162
                }
            
                if distanceDurationSegement.selectedSegmentIndex == 1 && indexPath.row == 4 {
                    return 162
                }
            }
        }
        
        return  0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if !editingRunDate {
                editingRunDate = true
            } else {
                editingRunDate = false
            }
            editingRunDistanceDuration = false
        
        } else if indexPath.row == 2 {
            if !editingRunDistanceDuration {
                editingRunDistanceDuration = true
            } else {
                editingRunDistanceDuration = false
            }
            editingRunDate = false
        }
        
        reloadTableViewCells()
    }
    
    func reloadTableViewCells() {
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "repeatPress" {
            if let destinationVC = segue.destinationViewController as? RepeatsTableViewController {
                destinationVC.setSelectedRepeatOption(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))?.detailTextLabel?.text?)
            }
        } else if segue.identifier == "repeatEndDatePress" {
            if let destinationVC = segue.destinationViewController as? RepeatSettingsTableViewController {
                destinationVC.setSelectedOption(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0))?.detailTextLabel?.text?)
            }
        }
        
    }
    
    func setRepeatDetailLabelText(repeatText: String) {
        if repeatText != "Never" {
            showRepeat = true
            reloadTableViewCells()
        } else {
            showRepeat = false
            reloadTableViewCells()
        }
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))?.detailTextLabel?.text = repeatText
    }
    
    func setRepeatEndDetailLabelText(repeatEndOption: String) {
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0))?.detailTextLabel?.text = repeatEndOption
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        var error = ""
        var planDistance = 0.0
        var planDuration = 0
        
        if distanceDurationSegement.selectedSegmentIndex == 0 {
            planDistance = plannedDistancePicker.selectedDistance().distance
        } else if distanceDurationSegement.selectedSegmentIndex == 1 {
            planDuration = plannedDurationPicker.selectedDuration().duration
        }
        
        if planDistance == 0 && planDuration == 0 {
            error += "A plan must have a distance or duration greater than 0. \n"
        }
        
        let stringValidation = runDetailsTextField.text.validateString("Plan details", maxLength: 40, minLength: 0)
        if !stringValidation.valid {
            error += "\(stringValidation.error) \n"
        }
        
        if error == "" {
            
            var timeInterval: Double = 0
            var repeatEndDate = NSDate()
            
            if showRepeat { //If this is true then a user is selecting a repeat option
                if let repeatCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0)) {
                    if let text = repeatCell.detailTextLabel?.text as String? {
                        switch text {
                        case "Every Day":
                            timeInterval = secondsInDay
                        case "Every Week":
                            timeInterval = secondsInDay * 7
                        case "Every 2 Weeks":
                            timeInterval = secondsInDay * 14
                        case "Every 3 Weeks":
                            timeInterval = secondsInDay * 21
                        case "Every 4 Weeks":
                            timeInterval = secondsInDay * 28
                        default:
                            println("Every Identifying Repeat Option")
                        }
                    }
                }
                if let endRepeatCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0)) {
                    if endRepeatCell.detailTextLabel?.text == "Until Plan End" {
                        repeatEndDate = NSDate(timeInterval: secondsInDay, sinceDate: plan!.endDate)
                    } else {
                        repeatEndDate = NSDate(timeInterval: secondsInDay, sinceDate: NSDate(shortDateString: endRepeatCell.detailTextLabel!.text!))
                    }
                }
                
                var plannedRunDates = plannedRunDate.date
                
                while plannedRunDates.compare(repeatEndDate) == .OrderedAscending {
                    let plannedRun = PlannedRun(ID: 0, date: plannedRunDates, distance: planDistance, duration: planDuration, details: runDetailsTextField.text)
                    Database().savePlannedRun(plannedRun, forPlan: plan)
                    plannedRunDates = NSDate(timeInterval: timeInterval, sinceDate: plannedRunDates)
                }
            } else {
                let plannedRun = PlannedRun(ID: 0, date: plannedRunDate.date, distance: planDistance, duration: planDuration, details: runDetailsTextField.text)
                
                Database().savePlannedRun(plannedRun, forPlan: plan)
            }
            self.navigationController!.popViewControllerAnimated(true)
        } else {
            println(error) //Handle validation error
        }
    }
}
