//
//  RepeatSettingsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 18/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RepeatSettingsTableViewController: UITableViewController {

    @IBOutlet weak var repeatEndDatePicker: UIDatePicker!
    @IBOutlet weak var dateDetailLabel: UILabel!
    
    var repeatEnd: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateDetailLabel.text = repeatEndDatePicker.date.shortDateString()
    }
    
    override func viewWillAppear(animated: Bool) {
        if repeatEnd == "Until Plan End" {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
                cell.accessoryType = .Checkmark
            }
        } else if let repeatEnd = repeatEnd {
            let repeatEndDate = NSDate(shortDateString: repeatEnd)
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))?.accessoryType = .Checkmark
            repeatEndDatePicker.date = repeatEndDate
            dateDetailLabel.text = repeatEnd
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        clearCheckmarks()
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if let viewControllers = self.navigationController?.viewControllers.count {
        
            if let previousVC = self.navigationController?.viewControllers[viewControllers - 2] as? NewPlannedRunTableViewController {
                if tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text == "Date" {
                    let selectedEndDate = repeatEndDatePicker.date.shortDateString()
                    previousVC.setRepeatEndDetailLabelText(selectedEndDate)
                } else {
                    if let selectedRepeatEndOption = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text {
                        previousVC.setRepeatEndDetailLabelText(selectedRepeatEndOption)
                    }
                }
            }
        }
    
        navigationController?.popViewControllerAnimated(true)
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
    
    // MARK: - Navigation

    @IBAction func endDatePickerValueChanged(sender: UIDatePicker) {
        dateDetailLabel.text = repeatEndDatePicker.date.shortDateString()
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))?.accessoryType = .Checkmark
    }
    
}
