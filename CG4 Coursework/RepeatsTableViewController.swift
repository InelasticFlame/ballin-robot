//
//  RepeatsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 18/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RepeatsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rowCount = tableView.numberOfRowsInSection(0)
        for var i = 0; i < rowCount; i++ {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))?.accessoryType = .None
        }
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if let viewControllers = self.navigationController?.viewControllers.count {
            
            if let previousVC = self.navigationController?.viewControllers[viewControllers - 2] as? NewPlannedRunTableViewController {
                if let selectedRepeatOption = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text {
                    previousVC.setRepeatDetailLabelText(selectedRepeatOption)
                }
            }
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation
    
    func setSelectedRepeatOption(repeatOption: String?) {
        
        //Fix this: - Check that table view is loaded before running this method
        
        let rowCount = tableView.numberOfRowsInSection(0)
        for var i = 0; i < rowCount; i++ {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) {
                if cell.textLabel?.text == repeatOption {
                    cell.accessoryType = .Checkmark
                }
            }
        }
    }
}
