//
//  InitialCreatePlanTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 10/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class InitialCreatePlanTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    //MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var endDateDetailLabel: UILabel!
    @IBOutlet weak var planNameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var warningLabel: UILabel!
    
    //MARK: - Global Variables
    private let secondsInDay: Double = 86400 //A global constant that stores the number of seconds in a day
    
    /* Boolean values that track whether the date picker cells are currently being shown */
    private var editingStartDate = false
    private var editingEndDate = false
    private var showNameWarning = false
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view initially loads.
    1. Sets the delegate of the planNameTextField to this viewController
    2. Adds a target to each date picker that calls the appropriate method whenever the date picker has its value changed
    3. Sets the minimum date for the endDatePicker to be the currently selected date of the start date picker plus 1 day
    4. Sets the minimum date for the startDatePicker to be today
    5. Updates the text of the startDateDetailLabel and endDateDetailLabel to the currently selected value from the date picker, using their short date strings
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planNameTextField.delegate = self //1
        startDatePicker.addTarget(self, action: "updateStartDate:", forControlEvents: .ValueChanged) //2
        endDatePicker.addTarget(self, action: "updateEndDate:", forControlEvents: .ValueChanged)
        
        endDatePicker.minimumDate = NSDate(timeInterval: secondsInDay, sinceDate: startDatePicker.date) //3
        startDatePicker.minimumDate = NSDate()
        startDateDetailLabel.text = startDatePicker.date.shortDateString() //5
        endDateDetailLabel.text = endDatePicker.date.shortDateString()
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
    
    //MARK: - Date Picker Control
    
    /**
    This method is called whenever the value of the start date picker is changed.
    1. Sets the text of the startDateDetailLabel to the selected date as a shortDateString
    2. Sets the minimum date of the endDatePicker as the selected date plus 1 day (So a plan cannot finish before it has started)
    3. Sets the text of the endDateDetailLabel to the selected date in the endDatePicker (this is in case changing the minimum date has caused the date of the endDatePicker to update, otherwise nothing will change)
    */
    func updateStartDate(sender: AnyObject) {
        startDateDetailLabel.text = startDatePicker.date.shortDateString()
        endDatePicker.minimumDate = NSDate(timeInterval: secondsInDay, sinceDate: startDatePicker.date)
        endDateDetailLabel.text = endDatePicker.date.shortDateString()
    }
    
    /**
    This method is called whenever the value of the end date picker is changed.
    1. Sets the text of the endDateDetailLabel to the selected date in the endDatePicker
    */
    func updateEndDate(sender: AnyObject) {
        endDateDetailLabel.text = endDatePicker.date.shortDateString()
    }
    
    //MARK: - Table View Data Source
    
    /**
    1. IF the current section is the second section
        a. IF the current row is the second row
            i. IF the user is editingStartDate return pickerRowHeight
           ii. ELSE return 0
        b. IF the current row is the fourth row
            i. IF the user is editingEndDate return pickerRowHeight
           ii. ELSE return 0
    2. IF the current section is the first section and the current row is the second row
        a. IF the planNameWarning needs to be shown return defaultRowHeight
        b. ELSE return 0
    3. In the default case, return the defaultRowHeight
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                if editingStartDate {
                    return Constants.TableView.PickerRowHeight
                } else {
                    return 0
                }
            } else if indexPath.row == 3 {
                if editingEndDate {
                    return Constants.TableView.PickerRowHeight
                } else {
                    return 0
                }
            }
        } else if indexPath.section == 0 && indexPath.row == 1 {
            if showNameWarning {
                return Constants.TableView.DefaultRowHeight
            } else {
                return 0
            }
        }
        
        return Constants.TableView.DefaultRowHeight
    }
    
    /**
    This method is called whenever a user selects a row in the table
    1. IF the selected row is in the second section
        a. IF the selected row is the first row
            b. IF the user is not already editing the startDate
                i. Set editingEndDate to false (hide the other picker)
               ii. Call the function reloadTableViewCells
              iii. Sets editingStartDate to true (show the new picker)
            c. ELSE sets editingStartDate to false (to hide the picker)
        d. IF the selected row is the third row
            e. IF the user is not already editing the endDate
                i. Set editingStartDate to false (hide the other picker)
               ii. Call the function reloadTableViewCells
              iii. Set editingEndDate to true (show the new picker)
            f. ELSE sets editingEndDate to false (to hide the picker)
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 { //1
            if indexPath.row == 0 { //a
                if !editingStartDate { //b
                    editingEndDate = false //i
                    reloadTableViewCells() //ii
                    editingStartDate = true //iii
                } else { //c
                    editingStartDate = false
                }
            } else if indexPath.row == 2 {
                if !editingEndDate {
                    editingStartDate = false
                    reloadTableViewCells()
                    editingEndDate = true
                } else {
                    editingEndDate = false
                }
            }
        }
        
        reloadTableViewCells()
    }
    
    /**
    This function is called whenever a new row is shown/hidden in the table view
    1. Calls the beginUpdates function of the table view, this tells the system that the following lines should be animated and performed
    2. Reloads the data in the table view
    3. Calls the endUpdates function
    */
    func reloadTableViewCells() {
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }

    // MARK: - Navigation

    /**
    This method is called by the system when is segue is about to be performed.
    1. IF the segue being performed is called "createPress"
        a. Calls the function createNewPlanWithName from the Database class, IF it returns a plan
            i. IF the destinationViewController for the segue is a CreatePlanTableViewController
                ii. Set the plan of the destinationViewController to the plan returned from the database
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createPress" { //1
            if let plan = Database().createNewPlanWithName(planNameTextField.text.capitalizedStringWithLocale(NSLocale.currentLocale()), startDate: startDatePicker.date, andEndDate:endDatePicker.date) as? Plan { //a
                
                if let destinationVC = segue.destinationViewController as? CreatePlanViewController { //i
                    destinationVC.plan = plan //ii
                }
            }
        }
    }
    
    /**
    This method is called by the system when the create button is pressed, it checks to see whether it should perform the transition to the next view.
    1. IF the segue to be performed is called "createPress"
        a. Calls the function validatePlanName, IF it returns true
            i. Returns true
        b. ELSE
            i. Sets showNameWarning to true
           ii. Sets the text of the warning label to the returned error
          iii. Calls the function reloadTableViewCells
           iv. Returns false
    2. In the default case returns true
    */
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "createPress" { //1
            let stringValidation = planNameTextField.text.validateString("A plan name", maxLength: 20, minLength: 3)
            if  stringValidation.valid { //a
                return true //i
            } else { //b
                showNameWarning = true //i
                warningLabel.text = stringValidation.error //ii
                reloadTableViewCells() //iii
                return false //iv
            }
        }
        
        return true //2
    }
}
