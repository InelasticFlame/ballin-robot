//
//  InitialCreatePlanTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 10/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class InitialCreatePlanTableViewController: UITableViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var editingStartDate = false
    var editingEndDate = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                if editingStartDate {
                    return 162
                } else {
                    return 0
                }
            } else if indexPath.row == 3 {
                if editingEndDate {
                    return 162
                } else {
                    return 0
                }
            }
        }
        
        return self.tableView.rowHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if !editingStartDate {
                    editingStartDate = true
                    editingEndDate = false
                    
                    reloadTableViewForDatePickers()
                    
                } else {
                    editingStartDate = false
                    
                    reloadTableViewForDatePickers()
                }
                
            } else if indexPath.row == 2 && !editingEndDate {
                editingEndDate = true
                editingStartDate = false
                
                reloadTableViewForDatePickers()
            }
        }
    }
    
    func reloadTableViewForDatePickers() {
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func updateStartDate() {
        editingStartDate = false
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
