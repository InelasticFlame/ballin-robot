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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateDetailLabel.text = repeatEndDatePicker.date.shortDateString()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let sectionCount = tableView.numberOfSections()
        
        for var j = 0; j < sectionCount; j++ {
            
            let rowCount = tableView.numberOfRowsInSection(j)
            
            for var i = 0; i < rowCount; i++ {
                let rowCount = tableView.numberOfRowsInSection(0)
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: j))?.accessoryType = .None
            }
        }
        
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
    
    // MARK: - Navigation
    
    func setSelectedOption(repeatEnd: String?) {

        //Fix this: - Check that table view is loaded before running this method
        
        println("Number of Sections: \(tableView.numberOfSections())") //DON'T GET RID OF THIS CAUSE SHIT WON'T WORK OTHERWISE; WE NEED THOSE EXTRA 0.023 SECONDS! Fuck you Jake.
        
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

    @IBAction func endDatePickerValueChanged(sender: UIDatePicker) {
        dateDetailLabel.text = repeatEndDatePicker.date.shortDateString()
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))?.accessoryType = .Checkmark
    }
    
}
