//
//  InitialCreatePlanTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 10/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class InitialCreatePlanTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var endDateDetailLabel: UILabel!
    @IBOutlet weak var planNameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var warningLabel: UILabel!

    // MARK: - Global Variables
    private let secondsInDay: Double = 86400 //A global constant that stores the number of seconds in a day

    /* Boolean values that track whether the date picker cells are currently being shown */
    private var editingStartDate = false
    private var editingEndDate = false
    private var showNameWarning = false

    // MARK: - View Life Cycle

    /**
    This method is called by the system when the view initially loads. It configures the view to the initial state.
    1. Sets the delegate of the planNameTextField to this viewController
    2. Adds a target to each date picker that calls the appropriate method whenever the date picker has its value changed
    3. Sets the minimum date for the endDatePicker to be the currently selected date of the start date picker plus 1 day
    4. Sets the minimum date for the startDatePicker to be today
    5. Updates the text of the startDateDetailLabel and endDateDetailLabel to the currently selected value from the date picker, using their short date strings
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        planNameTextField.delegate = self //1
        startDatePicker.addTarget(self, action: #selector(InitialCreatePlanTableViewController.updateStartDate), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(InitialCreatePlanTableViewController.updateEndDate), for: .valueChanged)

        endDatePicker.minimumDate = startDatePicker.date.add(1.days)
        startDatePicker.minimumDate = Date()
        startDateDetailLabel.text = startDatePicker.date.asShortDateString
        endDateDetailLabel.text = endDatePicker.date.asShortDateString
    }

    // MARK: - Text Field

    /**
    This method is called by the system when a user presses the return button on the keyboard whilst inputting into the text field.
    1. Dismisses the keyboard by removing the textField as the first responder for the view (the focus)
    2. Returns false
    
    :param: textField The UITextField whose return button was pressed.
    :returns: A boolean value indicating whether the text field's default behaviour should be perform (true) or not (false)
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //1

        return false //2
    }

    // MARK: - Date Picker Control

    /**
    This method is called whenever the value of the start date picker is changed. It updates the start date label and updates the minimum date of the end date picker.
    1. Sets the text of the startDateDetailLabel to the selected date as a shortDateString
    2. Sets the minimum date of the endDatePicker as the selected date plus 1 day (So a plan cannot finish before it has started)
    3. Sets the text of the endDateDetailLabel to the selected date in the endDatePicker (this is in case changing the minimum date has caused the date of the endDatePicker to update, otherwise nothing will change)
    
    :param: sender The object that called the action (in this case the startDatePicker).
    */
    @objc func updateStartDate(sender: AnyObject) {
        startDateDetailLabel.text = startDatePicker.date.asShortDateString
        endDatePicker.minimumDate = startDatePicker.date.add(1.days)
        endDateDetailLabel.text = endDatePicker.date.asShortDateString
    }

    /**
    This method is called whenever the value of the end date picker is changed. It updates the end date label.
    1. Sets the text of the endDateDetailLabel to the selected date in the endDatePicker
    
    :param: sender The object that called the action (in this case the endDatePicker).
    */
    @objc func updateEndDate(sender: AnyObject) {
        endDateDetailLabel.text = endDatePicker.date.asShortDateString
    }

    // MARK: - Table View Data Source

    /**
    This method is called by the system to return the height for a specific row in the table view.
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
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: indexPath The NSIndexPath of the row that's height is being requested.
    :returns: A CGFloat value that is the rows height.
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    This method is called whenever a user selects a row in the table. It updates which cells should be displayed and which cells should be hidden in the table view.
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
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 { //1
            if indexPath.row == 0 { //a
                if !editingStartDate { //b
                    editingEndDate = false //i
                    tableView.reloadTableViewCells() //ii
                    editingStartDate = true //iii
                } else { //c
                    editingStartDate = false
                }
            } else if indexPath.row == 2 {
                if !editingEndDate {
                    editingStartDate = false
                    tableView.reloadTableViewCells()
                    editingEndDate = true
                } else {
                    editingEndDate = false
                }
            }
        }

        tableView.reloadTableViewCells()
    }

    // MARK: - Navigation

    /**
    This method is called by the system when is segue is about to be performed. It sets up the new view.
    1. IF the segue being performed is called "createPress"
        a. Calls the function createNewPlanWithName from the Database class, IF it returns a plan
            i. IF the destinationViewController for the segue is a CreatePlanTableViewController
                ii. Set the plan of the destinationViewController to the plan returned from the database
    
    :param: segue The UIStoryboardSegue containing the information about the view controllers involved in the segue.
    :param: sender The object that caused the segue.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createPress" { //1
            if let plan = Database().createNewPlan(withName: planNameTextField.text!.capitalized, start: startDatePicker.date, andEnd: endDatePicker.date) as? Plan { //a

                if let destinationVC = segue.destination as? CreatePlanViewController { //i
                    destinationVC.plan = plan //ii
                }
            }
        }
    }

    /**
    This method is called by the system when the create button is pressed, it checks to see whether it should perform the transition to the next view.
    1. IF the segue to be performed is called "createPress"
        a. Calls the validates the planName, IF it is valid
            i. Returns true
        b. ELSE
            i. Sets showNameWarning to true
           ii. Sets the text of the warning label to the returned error
          iii. Calls the function reloadTableViewCells
           iv. Returns false
    2. In the default case returns true
    
    Uses the following local variables:
        stringValidation - A tuple of (boolean, string) that stores whether the plan name is valid and if it isn't any error that there is
    
    :param: identifier The string that identifies the triggered segue.
    :param: sender The object that initiated the segue.
    :returns: A boolean value indicating whether the segue should be performed.
    */
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if identifier == "createPress" { //1
            let stringValidation = planNameTextField.text!.validateString(stringName: "A plan name", maxLength: 20, minLength: 3)
            if  stringValidation.valid { //a
                return true //i
            } else { //b
                showNameWarning = true //i
                warningLabel.text = stringValidation.error //ii
                tableView.reloadTableViewCells() //iii
                return false //iv
            }
        }

        return true //2
    }
}
