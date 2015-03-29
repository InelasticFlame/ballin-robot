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
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var distanceDurationSegement: UISegmentedControl!
    @IBOutlet weak var plannedRunDatePicker: UIDatePicker!
    @IBOutlet weak var plannedDistancePicker: DistancePicker!
    @IBOutlet weak var plannedDurationPicker: DurationPicker!
    @IBOutlet weak var runDateDetailLabel: UILabel!
    @IBOutlet weak var runDistanceDurationDetailLabel: UILabel!
    @IBOutlet weak var runDetailsTextField: UITextField!
    
    // MARK: - Global Variables
    private let secondsInDay: Double = 86400 //A global double constant that stores the number of seconds in a day. Used to increase a date by 24 hours
    
    private var editingRunDate = false //A global boolean variable that tracks whether a user is editing the run date (so the run date picker should be shown)
    private var editingRunDistanceDuration = false //A global boolean variable that tracks whether a user is editing the runDistance or duration (so the runDistance or runDuration picker should be shown)
    private var showRepeat = false //A global boolean variable that tracks whether the user has selected a repeat option other than 'Never' so the repeatOptions cell should be displayed
    private var showError = false //A global boolean variable that tracks whether the error message cell should be displayed (because the planned run has failed a validation check)
    var plan: Plan? //A global optional variable plan object that stores the plan the runs are being created for
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is first loaded. It configures the view to its initial state.
    1. Sets the minimum date and maximum date of the plannedRunDate picker to the plan start and end dates respectively
    2. Calls the function updateDetailLabels (to setup the interface)
    3. Tells the plannedRunDate picker to call the function updateDetailLabels when its value is changed
    4. Tells the view controller to listen for the notification called "UpdateDetailLabel" and to call the function updateDetailLabels when it receives the notification
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        plannedRunDatePicker.minimumDate = plan?.startDate //Prevents a user from planning a run before the plan begins
        plannedRunDatePicker.maximumDate = plan?.endDate //Prevents a user from planning a run after the plan ends
        
        updateDetailLabels() //2
        
        plannedRunDatePicker.addTarget(self, action: "updateDetailLabels", forControlEvents: .ValueChanged) //3
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDetailLabels", name: "UpdateDetailLabel", object: nil) //4
    }

    //MARK: - Interface Updates
    
    /**
    This method is called by the system when the value of the distanceDuration segment is changed. It shows the correct picker view in the table view.
    1. Calls the function reloadTableViewCells (to show the correct picker based on the selected segment)
    2. Calls the function updateDetailLabel (to set the interface to the new type (distance or duration))
    
    :param: sender The UISegmentedControl that triggered the method to be called.
    */
    @IBAction func distanceDurationSegmentValueChanged(sender: UISegmentedControl) {
        tableView.reloadTableViewCells() //1
        updateDetailLabels() //2
    }
    
    /**
    This method is called when the view controller recieves the 'updateDetailLabels' notification. It is used to set the text of the detail labels to the values of the pickers.
    1. Sets the text of the runDateDetailLabel to the selected plannedRun date as a short date string
    2. IF the distanceDuration segment selected is the first segment (DISTANCE)
        a. Sets the runDistanceDuration label text to the plannedDistancePicker selected distance as a string
    3. ELSE (DURATION)
        b. Sets the runDistanceDuration label text to the plannedDurationPicker selected duration as a string
    */
    func updateDetailLabels() {
        runDateDetailLabel.text = plannedRunDatePicker.date.shortDateString() //1
        if distanceDurationSegement.selectedSegmentIndex == 0 { //2
            runDistanceDurationDetailLabel.text = plannedDistancePicker.selectedDistance().distanceStr //a
        } else if distanceDurationSegement.selectedSegmentIndex == 1 { //3
            runDistanceDurationDetailLabel.text = plannedDurationPicker.selectedDuration().durationStr //b
        }
    }
    
    //MARK: - Text Field
    
    /**
    This method is called by the system when a user presses the return button on the keyboard whilst inputting into the text field.
    1. Dismisses the keyboard by removing the textField as the first responder for the view (the focus)
    2. Returns false
    
    :param: textField The UITextField whose return button was pressed.
    :returns: A boolean value indicating whether the text field's default behaviour should be perform (true) or not (false)
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() //1
        
        return false //2
    }
    
    // MARK: - Table View Data Source

    /**
    This method is called by the system whenever the data in the table view is loaded. It returns the height for a row at a specific index path.
    1. IF the indexPath has a row of either 0, 2, 5 or 7 (these should always be displayed)
        a. Return the default row height
    2. ELSE IF the indexPath has a row of 8 and the repeat should be shown
        b. Return the default row height
    3. ELSE IF the indexPath has a row of 6 and the error should be shown
        c. Return the default row height
    4. ELSE
        d. IF the indexPath has a row of 1 and the user is editing the run date
            i. Return the picker row height
        e. IF the user is editing the run distance or duration
           ii. IF the selected segment in the distanceDuration segment is the first segment AND the indexPath has a row of 3 (DISTANCE)
                Z. Return the picker row height
          iii. IF the selected segment in the distanceDuration segment is the second segment AND the indexPath has a row of 4 (DURATION)
                Y. Return the picker row height
    5. In the default case return 0
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: indexPath The NSIndexPath of the row that's height is being requested.
    :returns: A CGFloat value that is the rows height.
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7 { //1
            return Constants.TableView.DefaultRowHeight //a
        } else if indexPath.row == 8 && showRepeat { //2
            return Constants.TableView.DefaultRowHeight //b
        } else if indexPath.row == 6 && showError { //3
            return Constants.TableView.DefaultRowHeight //c
        } else { //4
            if indexPath.row == 1 && editingRunDate { //d
                return Constants.TableView.PickerRowHeight //i
            }
            
            if editingRunDistanceDuration { //e
                if distanceDurationSegement.selectedSegmentIndex == 0 && indexPath.row == 3 { //ii
                    return Constants.TableView.PickerRowHeight //Z
                }
            
                if distanceDurationSegement.selectedSegmentIndex == 1 && indexPath.row == 4 { //iii
                    return Constants.TableView.PickerRowHeight //Y
                }
            }
        }
        
        return  0 //5
    }
    
    /**
    This method is called by the system whenever a user selects a row in the table view. It sets which picker views should be shown and which should be hidden.
    1. IF the selected cell is the first cell (DATE)
        a. Swap the value of editingRunDate
        b. Sets editingRunDistanceDuration to false
    2. IF the selected cell is the fourth cell (DISTANCE/DURATION)
        c. Swap the value of editingRunDistanceDuration
        d. Sets editingRunDate to false
    3. Calls the function reloadTableViewCells
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 { //1
            editingRunDate = !editingRunDate //a
            editingRunDistanceDuration = false //b
        
        } else if indexPath.row == 2 { //2
            editingRunDistanceDuration = !editingRunDistanceDuration //b
            editingRunDate = false //c
        }
        
        tableView.reloadTableViewCells() //3
    }

    //MARK: - Planned Run Saving
    
    /**
    This method is called by the system when the user presses the Done button. It validates the planned run and saves it to the database (if validation is successful) and then dismisses the view controller.
    1. Declares the local string variable error, the double variable planDistance and the integer variable planDuration
    2. Resigns the runDetailsTextField as the first responder (the focus) (this dismisses the keyboard)
    3. IF the run has a DISTANCE
        a. Sets the planDistance to the selected distance of the plannedDistancePicker
    4. ELSE IF the run has a DURATION
        b. Sets the planDuration to the selected duration of the plannedDurationPicker
    5. IF the planDistance and the planDuration equal 0
        c. Appends "A run must have distance or duration greater than 0."
    6. Validates the text in the run details textField
    7. IF the string isn't valid
        d. Appends the stringValidationError onto the error
    8. IF there isn't an error
        e. Declare the local double variable timeInterval and the local NSDate repeatEndDate
        f. Sets showError to false
        g. Calls the function reloadTableViewCells (if there was an error already displayed it should now be hidden)
        h. IF a user has selected a repeat
            i. Retrieve the repeatCell
           ii. Retrieve the text from the detail label of the repeat cel
          iii. Perform a switch on the text of the detail label
               iv. In the case of "Every Day" the timeInterval is secondsInDay
                v. In the case of "Every Week" the timeInterval is secondsInDay * 7
               vi. This is the continued for all repeat options
              vii. In the default case log "Error Identifying Repeat Option"
         viii. Retrieve the endRepeatCell
           ix. IF the detailLabel of the endRepeatCell has text "Until Plan End"
                x. The plannedRun should be repeated until the plan end date so set the repeatEndDate to the plan end date
           xi. ELSE
              xii. The plannedRun should be repeated until the date selected so set the repeatEndDate to the date created from the short date string of the endRepeatCell text
         xiii. Declare the local NSDate variable plannedRunDate and set its value to the plannedRunDatePicker date
          xiv. While the plannedRunDate is before the repeatEndDate
               xv. Create the planned run and save it to the database using the savePlannedRun method from the Database class
              xvi. Increase the plannedRunDate by the time interval
        i. ELSE
            j. Create the planned run and save it to the database using the savePlannedRun method from the Database class
        k. Dismiss the current view
    9. ELSE (there is an error)
        l. Sets the error cell text label text to the error
        m. Set show error to true
        n. Calls the function reloadTableViewCells to display the error
    
    Uses the following local variables:
        error - A string variable that stores any error
        planDistance - A double variable that stores the plan distance
        planDuration - An integer variable that stores the plan duration
        stringValidation - A tuple of (boolean, string) that stores whether the plan name is valid and if it isn't any error that there is
        timeInterval - A double variable that stores the time interval between repeated planned runs
        repeatEndDate - A variable NSDate of which to end the repetition on
        plannedRunDate - A variable NSDate that is the date of the planned run
        plannedRun - A Planned Run that is the planned run to add to the database
    
    :param: sender The object that called the action (in this case the Done button).
    */
    @IBAction func donePressed(sender: AnyObject) {
        var error = "" //1
        var planDistance = 0.0
        var planDuration = 0
        
        self.runDetailsTextField.resignFirstResponder() //2
        
        if distanceDurationSegement.selectedSegmentIndex == 0 { //3
            planDistance = plannedDistancePicker.selectedDistance().distance //a
        } else if distanceDurationSegement.selectedSegmentIndex == 1 { //4
            planDuration = plannedDurationPicker.selectedDuration().duration //b
        }
        
        if planDistance == 0 && planDuration == 0 { //5
            error += "A run must have a distance or duration greater than 0. \n" //c
        }
        
        let stringValidation = runDetailsTextField.text.validateString("Plan details", maxLength: 40, minLength: 0) //6
        if !stringValidation.valid { //7
            error += stringValidation.error + "\n" //d
        }
        
        if error == "" { //8
            var timeInterval: Double = 0 //e
            var repeatEndDate = NSDate()
            
            showError = false //f
            tableView.reloadTableViewCells() //g
            
            if showRepeat { //h
                if let repeatCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0)) { //i
                    if let text = repeatCell.detailTextLabel?.text as String? { //ii
                        switch text { //iii
                        case "Every Day": //iv
                            timeInterval = secondsInDay
                        case "Every Week": //v
                            timeInterval = secondsInDay * 7
                        case "Every 2 Weeks": //vi
                            timeInterval = secondsInDay * 14
                        case "Every 3 Weeks":
                            timeInterval = secondsInDay * 21
                        case "Every 4 Weeks":
                            timeInterval = secondsInDay * 28
                        default: //vii
                            println("Every Identifying Repeat Option")
                        }
                    }
                }
                
                if let endRepeatCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0)) { //viii
                    if endRepeatCell.detailTextLabel?.text == "Until Plan End" { //ix
                        repeatEndDate = NSDate(timeInterval: secondsInDay, sinceDate: plan!.endDate) //x
                    } else { //xi
                        repeatEndDate = NSDate(timeInterval: secondsInDay, sinceDate: NSDate(shortDateString: endRepeatCell.detailTextLabel!.text!)) //xii
                    }
                }
                
                var plannedRunDate = plannedRunDatePicker.date //xiii
                
                while plannedRunDate.compare(repeatEndDate) == .OrderedAscending { //xiv
                    let plannedRun = PlannedRun(ID: 0, date: plannedRunDate, distance: planDistance, duration: planDuration, details: runDetailsTextField.text) //xv
                    Database().savePlannedRun(plannedRun, forPlan: plan)
                    plannedRunDate = NSDate(timeInterval: timeInterval, sinceDate: plannedRunDate) //xvi
                }
            } else { //i
                let plannedRun = PlannedRun(ID: 0, date: plannedRunDatePicker.date, distance: planDistance, duration: planDuration, details: runDetailsTextField.text) //j
                
                Database().savePlannedRun(plannedRun, forPlan: plan)
            }
            self.navigationController!.popViewControllerAnimated(true) //k
        } else { //9
            self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 6, inSection: 0))?.textLabel?.text? = error //l
            showError = true //m
            self.tableView.reloadTableViewCells() //n
        }
    }
    
    // MARK: - Navigation
    
    /**
    This method is called by the system whenever a segue is about to be performed. It passes the relevant information to the destination view controller so that the view can be setup appropriately.
    1. IF the segue has the identifier "repeatPress"
        a. Retrieve the destination view controller as a RepeatsTableViewController
            i. Sets the repeatOption of the destinationVC to the detailLabel of the repeatOption cell
    2. ELSE IF the segue has idetifier "repeatEndDatePress"
        b. Retrieve the destination view controller as a RepeatSettingsTableViewController
           ii. Sets the repeatEnd of the destinationVC to the detailLabel of the repeatEnd cell
          iii. Sets the plannedRunDate of the destinationVC to the plannedRunDatePicker date
    
    :param: segue The UIStoryboardSegue containing the information about the view controllers involved in the segue.
    :param: sender The object that caused the segue.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "repeatPress" { //1
            if let destinationVC = segue.destinationViewController as? RepeatsTableViewController { //a
                destinationVC.repeatOption = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))?.detailTextLabel?.text? //i
            }
        } else if segue.identifier == "repeatEndDatePress" { //2
            if let destinationVC = segue.destinationViewController as? RepeatSettingsTableViewController { //b
                destinationVC.repeatEnd = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0))?.detailTextLabel?.text? //ii
                destinationVC.plannedRunDate = plannedRunDatePicker.date //iii
            }
        }
        
    }
    
    /**
    This method is called by the RepeatsTableViewController when a user selects a repeat. It is used to display the selected repeat on this view.
    1. IF The repeatText isn't "Never"
        a. Sets showRepeat to true (the user should now be able to set an end date for the repeat)
        b. Calls the function reloadTableViewCells
    2. ELSE
        c. Sets showRepeat to false
        d. Calls the function reloadTableViewCells
    3. Sets the text of the repeat cell detail label to the repeatText
    
    :param: repeatText The string for the selected repeat.
    */
    func setRepeatDetailLabelText(repeatText: String) {
        if repeatText != "Never" { //1
            showRepeat = true //a
            tableView.reloadTableViewCells() //b
        } else { //2
            showRepeat = false //c
            tableView.reloadTableViewCells() //d
        }
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))?.detailTextLabel?.text = repeatText //3
    }
    
    /**
    This method is called by the RepeatSettingsTableViewController when a user selects a setting for their repeat option. It is used to display the selected repeat end option on this view.
    1. Sets the text of the repeat setting detail label to the repeatEndOption
    
    :param: repeatEndOption The string of the selected end option for the repeat.
    */
    func setRepeatEndDetailLabelText(repeatEndOption: String) {
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0))?.detailTextLabel?.text = repeatEndOption
    }
}
