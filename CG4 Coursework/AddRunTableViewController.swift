//
//  AddRunTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 02/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddRunTableViewController: UITableViewController {

    var result = ""
    var lastSelectedPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateDetail(selectedValues: [String]) {
        var detailText = ""
        for i in selectedValues {
            detailText += " "
            detailText += i
        }
        
        self.tableView.cellForRowAtIndexPath(lastSelectedPath)?.detailTextLabel?.text = detailText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastSelectedPath = indexPath
        
        if indexPath.row == 0 {
            
        } else {
            createPickerView(indexPath)
        }
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    /**
    
    */
    func createPickerView(indexPath: NSIndexPath) {
        var pickerType = ""
        if indexPath.row == 1 {
            pickerType = Constants.PickerView.Type.Distance
        } else if indexPath.row == 2 {
            pickerType = Constants.PickerView.Type.Pace
        } else if indexPath.row == 3 {
            pickerType = Constants.PickerView.Type.Duration
        } else if indexPath.row == 4 {
            pickerType = Constants.PickerView.Type.RunType
        } else {
            pickerType = Constants.PickerView.Type.Shoe
        }
        
        
        let pickerViewController = AddRunPickerViewController(pickerType: pickerType)
        pickerViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.presentViewController(pickerViewController, animated: true, completion: nil)
    }
}
