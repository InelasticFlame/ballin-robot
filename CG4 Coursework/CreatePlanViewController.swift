//
//  CreatePlanViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 16/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var secondNavigationItem: UINavigationItem!
    @IBOutlet weak var plannedRunsTableView: UITableView!
    
    //MARK: - Global Variables
    var plan: Plan? //A global optional variable that stores a Plan object. This is used to track the plan being eddited currently.
    
    // MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is first loaded.
    1. Hides the back button of the navigation bar
    2. Sets the dataSource and delegate of the plannedRunsTableView to this view controller
    3. Sets the right button of the bottom navigation item to an edit button
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true //1
        
        plannedRunsTableView.dataSource = self //2
        plannedRunsTableView.delegate = self
        
        secondNavigationItem.rightBarButtonItem = self.editButtonItem() //3
    }
    
    /**
    This method is called by the system whenever the view is about to appear on screen.
    1. Loads the plannedRuns for the current plan
    2. Reloads the data in the tableView
    */
    override func viewWillAppear(animated: Bool) {
        plan?.loadPlannedRuns()
        plannedRunsTableView.reloadData()
    }
    
    //MARK: - Editing
    
    /**
    This method is called by the system when the edit button is pressed.
    1. Sets the plannedTableView to the editing option passed and the animation option passsed
    */
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        plannedRunsTableView.setEditing(editing, animated: animated) //1
    }
    
    // MARK: - TableView Data Source
    
    /**
    This method is called by the system whenever the data in the table view is loaded, it returns the number of sections in the table view which in this case is fixed 1.
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
    This method is called by the system whenever the data in the table view is loaded, it returns the number of rows in the table view. In this case, IF there is a plan it returns the number of plannedRuns; otherwise it returns 0
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let plan = plan {
            return plan.plannedRuns.count
        }
        
        return 0
    }
    
    /**
    This method is called by the system whenever the data in the table view is loaded. It creates a new cell and populates it with the appropriate data.
    1. Creates a new cell with the identifier "PlannedRun"
    2. Declares the local constant plannedRun, which is the plannedRun with the index of the current row
    3. Sets the dateLabel text of of the cell to the plannedRun's date as a shortestDateString (dd/mm/yy)
    4. Sets the detailsLabel text to the details of the plannedRun
    5. IF the plannedRun has a distance greater than 0
        a. Sets the text of the distanceDurationLabel to the plannedRun distance converted to a string using the Conversions class
    6. ELSE 
        b. Sets the text of the distanceDurationLabel to the plannedRun duration converted to a string using the Conversions class
    7. Returns the cell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlannedRun", forIndexPath: indexPath) as PlannedRunTableViewCell //1
        let plannedRun = plan?.plannedRuns[indexPath.row] //2
        
        cell.dateLabel.text = plannedRun?.date.shortestDateString() //3
        cell.detailsLabel.text = plannedRun?.details //4
        if plannedRun?.distance > 0 { //5
            cell.distanceDurationLabel.text = Conversions().distanceForInterface(plannedRun!.distance) //a
        } else { //6
            cell.distanceDurationLabel.text = Conversions().runDurationForInterface(plannedRun!.duration) //b
        }
        
        return cell //7
    }
    
    /**
    This method is called by the system whenever the ata in the table view is loaded. It returns the height for a cell at a certain indexPath, in this case all cells have a fixed height of 60
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    /**
    This method is called when a user presses the delete button whilst the table is in edit mode.
    1. IF the edit being performed is a delete
        a. IF there is a plan
            b. Calls the function deletePlannedRun from the Database class passing the plannedRun at the index of the current row; IF it is succesful
                i. Remove the plannedRun from the array
               ii. Delete the row at the indexPath with the animation of a Fade
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { //1
            if let plan = plan { //a
                if Database().deletePlannedRun(plan.plannedRuns[indexPath.row]) { //b
                    plan.plannedRuns.removeAtIndex(indexPath.row) //i
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) //ii
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    /**
    This method is called by the system whenever a segue is about to be performed.
    1. IF the destination view controller is a NewPlannedRunTableViewController
        a. IF there is a plan
            i. Set the plan of the destination view controller to the plan
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? NewPlannedRunTableViewController { //1
            if let plan = plan { //a
                destinationVC.plan = plan //i
            }
        }
    }
    
    /**
    This method is called by the system when the 'Done' button is pressed
    1. Dismiss the current view controller
    */
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true) //1
    }
}
