//
//  CreatePlanViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 16/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var secondNavigationItem: UINavigationItem!
    @IBOutlet weak var plannedRunsTableView: UITableView!

    // MARK: - Global Variables
    var plan: Plan? //A global optional variable that stores a Plan object. This is used to track the plan being edited currently.

    // MARK: - View Life Cycle

    /**
    This method is called by the system when the view is first loaded. It configures the view to its initial state.
    1. Hides the back button of the navigation bar
    2. Sets the dataSource and delegate of the plannedRunsTableView to this view controller
    3. Sets the right button of the bottom navigation item to an edit button
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true //1

        plannedRunsTableView.dataSource = self //2
        plannedRunsTableView.delegate = self

        secondNavigationItem.rightBarButtonItem = self.editButtonItem //3
    }

    /**
    This method is called by the system whenever the view is about to appear on screen. It loads the planned runs and reloads the table view to display the planned runs on the interface.
    1. Loads the plannedRuns for the current plan
    2. Reloads the data in the tableView
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        plan?.loadPlannedRuns()
        plannedRunsTableView.reloadData()
    }

    // MARK: - Editing

    /**
    This method is called by the system when the edit button is pressed. It sets the table view into edit mode.
    1. Sets the plannedTableView to the editing option passed and the animation option passed
    */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        plannedRunsTableView.setEditing(editing, animated: animated) //1
    }

    // MARK: - TableView Data Source

    /**
    This method is called by the system whenever the data in the table view is loaded, it returns the number of sections in the table view which in this case is fixed 1.
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :returns: An integer value that is the number of sections in the table view.
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /**
    This method is called by the system whenever the data in the table view is loaded, it returns the number of rows in the table view. In this case, IF there is a plan it returns the number of plannedRuns; otherwise it returns 0
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: section The section that's number of rows needs returning as an integer.
    :returns: An integer value that is the number of rows in the section.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    Uses the following local variables:
        cell - A PlannedRunTableViewCell that is the cell to display at the current indexPath
        plannedRun - The Planned Run object for the current cell
    
    :param: tableView The UITableView that is requesting the cell.
    :param: indexPath The NSIndexPath of the cell requested.
    :returns: The UITableViewCell for the indexPath.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannedRun", for: indexPath as IndexPath) as! PlannedRunTableViewCell //1
        let plannedRun = plan?.plannedRuns[indexPath.row] //2

        cell.dateLabel.text = plannedRun?.date.toShortestDateString //3
        cell.detailsLabel.text = plannedRun?.details //4
        if plannedRun!.distance > 0 { //5
            cell.distanceDurationLabel.text = plannedRun!.distance.toString(Miles.unit) //a
        } else { //6
            cell.distanceDurationLabel.text = Conversions().runDurationForInterface(duration: plannedRun!.duration) //b
        }

        return cell //7
    }

    /**
    This method is called by the system whenever the data in the table view is loaded. It returns the height for a cell at a certain indexPath, in this case all cells have a fixed height of 60
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: indexPath The NSIndexPath of the row that's height is being requested.
    :returns: A CGFloat value that is the rows height.
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    /**
    This method is called when a user presses the delete button whilst the table is in edit mode. It deletes a planned run from the database and from the tableview.
    1. IF the edit being performed is a delete
        a. IF there is a plan
            b. Calls the function deletePlannedRun from the Database class passing the plannedRun at the index of the current row; IF it is succesful
                i. Remove the plannedRun from the array
               ii. Delete the row at the indexPath with the animation of a Fade
    
    :param: tableView The UITableView that is requesting the insertion of the deletion.
    :param: editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath.
    :param: indexPath The NSIndexPath of the cell that the deletion or insertion is to be performed on.
    */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //1
            if let plan = plan { //a
                if Database().deletePlannedRun(plan.plannedRuns[indexPath.row]) { //b
                    plan.plannedRuns.remove(at: indexPath.row) //i
                    tableView.deleteRows(at: [indexPath as IndexPath], with: .fade) //ii
                }
            }
        }
    }

    // MARK: - Navigation

    /**
    This method is called by the system whenever a segue is about to be performed. It configures the new view.
    1. IF the destination view controller is a NewPlannedRunTableViewController
        a. IF there is a plan
            i. Set the plan of the destination view controller to the plan
    
    :param: segue The UIStoryboardSegue containing the information about the view controllers involved in the segue.
    :param: sender The object that caused the segue.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewPlannedRunTableViewController { //1
            if let plan = plan { //a
                destinationVC.plan = plan //i
            }
        }
    }

    /**
    This method is called by the system when the 'Done' button is pressed. It is used to dismiss the current view.
    1. Dismiss the current view controller
    
    :param: sender The object that called the action (in this case the Done button).
    */
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true) //1
    }
}
