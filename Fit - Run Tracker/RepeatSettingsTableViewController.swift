//
//  RepeatSettingsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 18/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RepeatSettingsTableViewController: UITableViewController {

    // MARK: - Storyboard Links
    @IBOutlet weak var repeatEndDatePicker: UIDatePicker! //Date picker that is used to set the end date of the repeat
    @IBOutlet weak var dateDetailLabel: UILabel! //The detail label of the date picker's cell

    // MARK: - Global Variables

    var repeatEnd: String? //A global string variable that stores the selected repeat end option (if one has been previously set). This value is set by the NewPlannedRunTableView controller when the segue to this view is called.
    var plannedRunDate: Date? //A global optional NSDate variable that stores the date of the planned run. This is so that the repeat end cannot be set to before the planned run date.

    // MARK: - View Life Cycle

    /**
    This method is called by the system whenever the view is about to appear on screen. It configures the view to its initial state.
    1. Sets the minimum date of the repeatEndDatePicker to the plannedRunDate (repetition cannot end before the planned run has even started!)
    2. Sets the dateDetailLabel text to the current date of the repeatEndDatePicker
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        repeatEndDatePicker.minimumDate = plannedRunDate //1
        dateDetailLabel.text = repeatEndDatePicker.date.toShortDateString //2
    }

    /**
    This method is called by the system when the view appears on screen. It is used to set the previous selected repeat end option (if there is one).
    1. Calls the function setPreviousRepeatEnd
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewDidAppear(_ animated: Bool) {
        setPreviousRepeatEnd() //1
    }

    // MARK: Table View Data Source

    /**
    This method is called by the system whenever a user selects a row in the table view. It sets the new repeat end option and dismisses the view.
    1. Calls the function clearCheckmarks (so that only one row at a time can be chosen as the selected option)
    2. Sets the accessory of the cell selected to a Checkmark
    3. Deselects the cell that was just selected animating the process
    4. IF the current number of view controllers can be counted
        a. IF the previousViewController is a NewPlannedRunTableViewController (the previous view controller will be the one at the index that is 2 less than the count (since counts start from 1 and indexes start at 0))
            b. IF the text of the selected cell is 'Date'
                i. Calls the function setRepeatEndDetailLabelText on the previous view controller passing the date selected from the repeatEndDatePicker
            c. ELSE Calls the function setRepeatEndDetailLabelText on the previous view controller passing the text from the selected cell
    5. Dismiss the current view controller and animate the transition
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearCheckmarks() //1

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark //2
        tableView.deselectRow(at: indexPath, animated: true) //3

        if let viewControllers = self.navigationController?.viewControllers.count { //4

            if let previousVC = self.navigationController?.viewControllers[viewControllers - 2] as? NewPlannedRunTableViewController { //a
                if tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.text == "Date" { //b
                    let selectedEndDate = repeatEndDatePicker.date.toShortDateString
                    previousVC.setRepeatEndDetailLabelText(repeatEndOption: selectedEndDate) //i
                } else { //c
                    if let selectedRepeatEndOption = tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.text {
                        previousVC.setRepeatEndDetailLabelText(repeatEndOption: selectedRepeatEndOption)
                    }
                }
            }
        }

        navigationController?.popViewController(animated: true) //5
    }

    /**
    This method is called when the view is about to appear on screen. It sets a checkmark on the cell that was previously by the user (if one has been selected).
    1. IF the repeatEnd is Until Plan End
        a. Sets the accessory of the cell first cell in the first section to a checkmark
    2. ELSE
        a. Declares the local constant repeatEndDate as an NSDate object created using the repeatEnd
        b. Sets the accessory of the first cell in the second section to a checkmark
        c. Sets the date of the endDatePicker to the previously selected date
        d. Sets the text of the dateDetailLabel to the repeatEnd
    
    Uses the following local variables:
        repeatEndDate - A constant string that is the date to end repeats as a string
    */
    func setPreviousRepeatEnd() {
        if repeatEnd == "Until Plan End" { //1
            tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .checkmark //a
        } else if let repeatEnd = repeatEnd { //2
            let repeatEndDate = Date(shortDateString: repeatEnd) //a
            tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.accessoryType = .checkmark //b
            repeatEndDatePicker.date = repeatEndDate //c
            dateDetailLabel.text = repeatEnd //d
        }
    }

    /**
    This method is used to remove the accessory from all cells. This is so that if a new shoe is selected two checkmarks are not shown on the interface (such that it appears as if 2 rows have been selected)
    1. Declares the local constant sectionCount and sets its value to the number of sections in the table view
    2. FOR each section
        a. Declares the local constant rowCount and sets its value to the number of rows in the current section
        b. FOR each row
            i. Sets the accessory of the cell in the current section for the current row to None
    
    Uses the following local variables:
        sectionCount - An integer constant that is the number of sections in the table view
        sectionNo - An integer variable that is the current section being cleared
        rowCount - An integer constant that is the number of rows in a certain section
        rowNo - An integer variable that is the current row in a section
    */
    func clearCheckmarks() {
        let sectionCount = tableView.numberOfSections //1

        for sectionNo in 0 ..< sectionCount { //2

            let rowCount = tableView.numberOfRows(inSection: sectionNo) //a

            for rowNo in 0 ..< rowCount { //b
                tableView.cellForRow(at: IndexPath(row: rowNo, section: sectionNo))?.accessoryType = .none //i
            }
        }
    }

    // MARK: - Interface Actions

    /**
    This method is called by the system when the endDatePicker has its selected date changed. It updates the interface with this new value.
    1. Sets the text of the dateDetailLabel to the selected date as a short date string
    2. Calls the function clearCheckmarks
    3. Sets the accessory of the first cell in the second section to a Checkmark
    
    :param: sender The UIDatePicker that triggered the method to be called.
    */
    @IBAction func endDatePickerValueChanged(sender: UIDatePicker) {
        dateDetailLabel.text = repeatEndDatePicker.date.toShortDateString //1
        clearCheckmarks() //2
        tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.accessoryType = .checkmark //3
    }

}
