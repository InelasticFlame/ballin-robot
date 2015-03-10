//
//  MoreTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 10/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    /**
    1. IF the selected cell has a row of 3
        a. Load the storyboard "MainStoryboard"
        b. Load the new view controller as the viewController called "setupStoryboard" from the loaded storyboard
        c. Show the new view controller
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 { //1
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil) //a
            let newVC = storyboard.instantiateViewControllerWithIdentifier("setupStoryboard") as UIViewController //b
            self.presentViewController(newVC, animated: true, completion: nil) //c
        }
    }
}
