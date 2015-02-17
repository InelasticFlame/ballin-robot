//
//  TrainingPlansTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 16/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class TrainingPlansTableViewController: UITableViewController {

    var plans = [[Plan](), [Plan]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    /**
    This method is called each time the view will appear on screen.
    1. Clears the arrays of any existing plans
    2. Retrieves the plans from the database using the Database class
    3. FOR each plan in unsortedPlans
        a. IF the plan is active
            i. Add the plan to the first array (Active Plans)
        b. ELSE
            i. Adds the plan to the second array (In-active Plans)
    */
    override func viewWillAppear(animated: Bool) {
        plans[0].removeAll(keepCapacity: false)
        plans[1].removeAll(keepCapacity: false)
        
        let unsortedPlans: [Plan] = Database().loadAllTrainingPlans() as [Plan]
        
        for plan: Plan in unsortedPlans {
            if plan.active {
                plans[0].append(plan)
            } else {
                plans[1].append(plan)
            }
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return plans[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("activePlan", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = plans[0][indexPath.row].name
            cell.detailTextLabel?.text = Conversions().dateToString(plans[0][indexPath.row].endDate)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("inactivePlan", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = plans[1][indexPath.row].name
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Active Plans"
        } else {
            return "In-active Plans"
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
