//
//  HomeTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    override func viewDidAppear(animated: Bool) {
        
        if !NSUserDefaults.standardUserDefaults().boolForKey(Constants.DefaultsKeys.InitialSetup.SetupKey) {
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let setupVC = storyboard.instantiateViewControllerWithIdentifier("setupStoryboard") as UIViewController
            self.presentViewController(setupVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //Returns the number of sections in the table view (4 is used for a section per card)
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Returns the number of rows in each section (1 is used for 1 card per section)
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellHeaders = ["Miles Ran This Month", "Today's Calories", "My Shoes", "Personal Bests"]

        if indexPath.section < 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProgressCard", forIndexPath: indexPath) as HomeProgressTableViewCell
            cell.headerLabel.text = cellHeaders[indexPath.section]
            cell.headerImageView.image = UIImage(named: cellHeaders[indexPath.section])
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TextCard", forIndexPath: indexPath) as HomeTextTableViewCell
            
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.view.frame.width*0.9
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}
