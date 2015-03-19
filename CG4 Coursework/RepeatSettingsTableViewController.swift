//
//  RepeatSettingsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 18/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RepeatSettingsTableViewController: UITableViewController {

    //MARK: - Storyboard Links
    @IBOutlet weak var repeatEndDatePicker: UIDatePicker! //Date picker that is used to set the end date of the repeat
    @IBOutlet weak var dateDetailLabel: UILabel! //The detail label of the date picker's cell
    
    //MARK: - Global Variables
    
    var repeatEnd: String? //A global string variable that stores the selected repeat end option (if one has been previously set). This value is set by the NewPlannedRunTableView controller when the segue to this view is called.
    var plannedRunDate: NSDate?
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system whenever the view is about to appear on screen.
    1. Calls the function setPreviousRepeatEnd
    2. Sets the dateDetailLabel text to the current date of the repeatEndDatePicker
    3. Sets the minimum date of the repeatEndDatePicker to the plannedRunDate (repetition cannot end before the planned run has even started!)
    */
    override func viewWillAppear(animated: Bool) {
        setPreviousRepeatEnd() //1
        dateDetailLabel.text = repeatEndDatePicker.date.shortDateString() //2
        repeatEndDatePicker.minimumDate = plannedRunDate //3
    }
    
    //MARK: Table View Data Source
    
    /**
    This method is called by the system whenever a user selects a row in the table view.
    1. Calls the function clearCheckmarks (so that only one row at a time can be chosen as the seleccted option)
    2. Sets the accessory of the cell selected to a Checkmark
    3. Deselects the cell that was just selected animating the process
    4. IF the current number of view controllers can be counted
        a. IF the previousViewController is a NewPlannedRunTableViewController (the previous view controller will be the one at the index that is 2 less than the count (since counts start from 1 and indexes start at 0))
            b. IF the text of the selected cell is 'Date'
                i. Calls the function setRepeatEndDetailLabelText on the previous view controller passing the date selected from the repeatEndDatePicker
            c. ELSE Calls the function setRepeatEndDetailLabelText on the previous view controller passing the text from the selected cell
    5. Dismiss the current view controller and animate the transition
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        clearCheckmarks() //1
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark //2
        tableView.deselectRowAtIndexPath(indexPath, animated: true) //3
        
        
        if let viewControllers = self.navigationController?.viewControllers.count { //4
        
            if let previousVC = self.navigationController?.viewControllers[viewControllers - 2] as? NewPlannedRunTableViewController { //a
                if tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text == "Date" { //b
                    let selectedEndDate = repeatEndDatePicker.date.shortDateString()
                    previousVC.setRepeatEndDetailLabelText(selectedEndDate) //i
                } else { //c
                    if let selectedRepeatEndOption = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text {
                        previousVC.setRepeatEndDetailLabelText(selectedRepeatEndOption)
                    }
                }
            }
        }
    
        navigationController?.popViewControllerAnimated(true) //5
    }
    
    /**
    This method is called when the view is about to appear on screen. It sets a checkmark on the cell that was previously by the user (if one has been selected)
    1. IF the repeatEnd is Until Plan End
        a. Sets the accessory of the cell first cell in the first section to a checkmark
    2. ELSE
        a. Declares the local constant repeatEndDate as an NSDate object created using the repeatEnd
        b. Sets the accessory of the first cell in the second section to a checkmark
        c. Sets the date of the endDatePicker to the previously selected date
        d. Sets the text of the dateDetailLabel to the repeatEnd
    */
    func setPreviousRepeatEnd() {
        if repeatEnd == "Until Plan End" { //1
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.accessoryType = .Checkmark //a
        } else if let repeatEnd = repeatEnd { //2
            let repeatEndDate = NSDate(shortDateString: repeatEnd) //a
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))?.accessoryType = .Checkmark //b
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
    */
    func clearCheckmarks() {
        let sectionCount = tableView.numberOfSections()
        
        for var sectionNo = 0; sectionNo < sectionCount; sectionNo++ {
            
            let rowCount = tableView.numberOfRowsInSection(sectionNo)
            
            for var rowNo = 0; rowNo < rowCount; rowNo++ {
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowNo, inSection: sectionNo))?.accessoryType = .None
            }
        }
    }
    
    //MARK: - Interface Actions
    
    /**
    This method is called by the system when the endDatePicker has its selected date changed.
    1. Sets the text of the dateDetailLabel to the selected date as a short date string
    2. Sets the accessory of the first cell in the second section to a Checkmark
    3. Calls the function clearCheckmarks
    */
    @IBAction func endDatePickerValueChanged(sender: UIDatePicker) {
        dateDetailLabel.text = repeatEndDatePicker.date.shortDateString()
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))?.accessoryType = .Checkmark
        clearCheckmarks()
    }
    
}
