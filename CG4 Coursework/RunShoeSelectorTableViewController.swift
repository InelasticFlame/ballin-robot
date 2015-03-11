//
//  RunShoeSelectorTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 11/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RunShoeSelectorTableViewController: UITableViewController {

    var shoes = [Shoe]()
    var selectedShoe: Shoe?
    
    override func viewWillAppear(animated: Bool) {
        shoes = Database().loadAllShoes() as [Shoe]
        
        tableView.reloadData()
        
        if let selectedShoe = selectedShoe {
            for var i = 0; i < shoes.count; i++ {
                if selectedShoe.ID == shoes[i].ID {
                    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i + 1, inSection: 0))?.accessoryType = .Checkmark
                }
            }
        } else {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.accessoryType = .Checkmark
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return shoes.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shoeCell", forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "None"
        } else {
            cell.textLabel?.text = shoes[indexPath.row - 1].name
        }
        
        
        return cell
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
            
            if let previousVC = self.navigationController?.viewControllers[viewControllers - 2] as? RunShoesTableViewController {
                previousVC.selectedShoe = shoes[indexPath.row - 1]
                
                //FIXME: Save shoe
            }
        }
        
        navigationController?.popViewControllerAnimated(true)
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
