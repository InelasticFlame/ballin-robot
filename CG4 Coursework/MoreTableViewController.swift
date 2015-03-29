//
//  MoreTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 10/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    //MARK: - Table View Data Source
    
    /**
    This method is called when a user selects a row in the table view. It is used to load the setup view if the user presses the third cell.
    1. IF the selected cell has a row of 2
        a. Load the storyboard "MainStoryboard"
        b. Load the new view controller as the viewController called "setupStoryboard" from the loaded storyboard
        c. Show the new view controller
    
    Uses the following local variables:
        storyboard - A constant UIStoryboard that is the main story board
        newVC - A constant UIViewController that is the setup view controller
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 { //1
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil) //a
            let newVC = storyboard.instantiateViewControllerWithIdentifier("setupStoryboard") as UIViewController //b
            self.presentViewController(newVC, animated: true, completion: nil) //c
        }
    }
}
