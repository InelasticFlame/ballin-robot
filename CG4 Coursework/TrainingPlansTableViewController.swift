//
//  TrainingPlansTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 16/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class TrainingPlansTableViewController: UITableViewController {

    private var plans = [[Plan](), [Plan]()] //A global array that contains 2 arrays of Plan objects, [[ActivePlans], [InactivePlans]]
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is first loaded
    1. Sets the right button on the navigation bar as an Edit button
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem() //1
    }
    
    /**
    This method is called each time the view will appear on screen. It is used to load the plans and sort them into active and in active to then display them in the table view.
    1. Clears the arrays of any existing plans, without keeping its current size
    2. Retrieves the plans from the database using the Database class as an array of Plan objects
    3. FOR each plan in unsortedPlans
        a. IF the plan is active
            i. Add the plan to the first array (Active Plans)
        b. ELSE
            i. Adds the plan to the second array (In-active Plans)
    4. Reloads the data in the table view
    
    Using the following local variables:
        unsortedPlans - An immutable array of Plan objects that stores all the plans from the database 
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(animated: Bool) {
        plans[0].removeAll(keepCapacity: false) //1
        plans[1].removeAll(keepCapacity: false)
        
        let unsortedPlans: [Plan] = Database().loadAllTrainingPlans() as [Plan] //1
        
        for plan: Plan in unsortedPlans { //3
            if plan.active { //3a
                plans[0].append(plan) //3ai
            } else { //3b
                plans[1].append(plan) //3bi
            }
        }
        
        tableView.reloadData() //4
    }

    // MARK: - Table view data source

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of sections in the table, which in this case is fixed as 2.
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :returns: An integer value that is the number of sections in the table view.
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of rows in a section, which is the number of plans in the array of plans for the current section.
    (ActivePlans in section 0, InactivePlans in section 1)
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: section The section that's number of rows needs returning as an integer.
    :returns: An integer value that is the number of rows in the section.
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans[section].count
    }

    /**
    This method is called by the system when the data is loaded in the table, it creates a new cell and populates it with the data for a particular Plan.
    1. IF the section is 0
        a. Create an 'activePlan' cell
        b. Set the textLabel text to the name of the ActivePlan at the current row
        c. Sets the detailTextLabel text to the endDate of the ActivePlan at the current row, as a shortDateString
        d. Returns the cell
    2. ELSE
        a. Creates an 'inactivePlan' cell
        b. Set the textLabel text to the name of the InactivePlan at the current row
        c. Returns the cell
    
    Uses the following local variables:
        cell - A UITableView cell for the current indexPath
    
    :param: tableView The UITableView that is requesting the cell.
    :param: indexPath The NSIndexPath of the cell requested.
    :returns: The UITableViewCell for the indexPath.
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //1
            let cell = tableView.dequeueReusableCellWithIdentifier("activePlan", forIndexPath: indexPath) as UITableViewCell //1a
            cell.textLabel?.text = plans[0][indexPath.row].name //1b
            cell.detailTextLabel?.text = plans[0][indexPath.row].endDate.shortDateString() //1c
            
            return cell //1d
        } else { //2
            let cell = tableView.dequeueReusableCellWithIdentifier("inactivePlan", forIndexPath: indexPath) as UITableViewCell //2a
            cell.textLabel?.text = plans[1][indexPath.row].name //2b
            
            return cell //2c
        }
    }
    
    /**
    This method is called by the system whenever the tableView loads it data. It returns the title for the header of a section.
    1. IF the section is 0, return "Active Plans"
    2. ELSE return "In-active Plans"
    */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { //1
            return "Active Plans"
        } else { //2
            return "In-active Plans"
        }
    }

    /**
    This method is called when a user presses the delete button whilst the table is in edit mode. It removes the training plan from the database and from the table view.
    1. IF the edit being performed is a delete
        a. IF the plan for the selected row in the selected section is successfully deleted from the database
            i. Remove the plan from the array of plans
           ii. Remove the row selected with the Fade animation
    
    :param: tableView The UITableView that is requesting the insertion of the deletion.
    :param: editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath.
    :param: indexPath The NSIndexPath of the cell that the deletion or insertion is to be performed on.
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { //1
            if Database().deletePlan(plans[indexPath.section][indexPath.row]) { //a
                plans[indexPath.section].removeAtIndex(indexPath.row) //i
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) //ii
            }
        }
    }
    
    // MARK: - Navigation

    /**
    This method is called by the system when it is about to perform a segue. It is used to configure the new view.
    1. IF the destination view controller is a PlanDetailsViewController
        a. IF the selectedIndex for the cell is successfully retrieved
            i. Set the plan property of the destination view controller to the plan for the selected row in the selected section
    
    :param: segue The UIStoryboardSegue containing the information about the view controllers involved in the segue.
    :param: sender The object that caused the segue.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? PlanDetailsViewController { //1
            if let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell) { //1a
                destinationVC.plan = plans[selectedIndex.section][selectedIndex.row] //1ai
            }
        }
    }
}
