//
//  NewPlannedRunTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class NewPlannedRunTableViewController: UITableViewController {
    
    // MARK: - Storyboard Links
    @IBOutlet weak var distanceDurationSegement: UISegmentedControl!
    @IBOutlet weak var distanceDurationPicker: UIPickerView!

    // MARK: - Global Variables
    var editingRunDate = false
    var editingRunDistanceDuration = false
    var showRepeat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func distanceDurationSegmentValueChanged(sender: UISegmentedControl) {
        reloadTableViewCells()
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
}
