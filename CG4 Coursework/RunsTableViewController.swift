//
//  RunsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 27/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class RunsTableViewController: UITableViewController {
    //MARK: - Global Variables
    
    var runs = [Run]() //Creates and inititalises a global array of Run objects
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is first loaded
    1. Sets the right button on the navigation bar as an Edit button
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem() //1
    }
    
    /**
    This method reloads the data in the table when the view is about to appear, this ensures that the table is always up to date after further navigation through the app (the view is not reloaded fully each time)
    1. Loads all the runs from the database, storing them in the global array of Run objects, runs
    2. Reloads the tableView
    */
    override func viewWillAppear(animated: Bool) {
        self.runs = Database().loadRunsWithQuery("") as Array<Run> //1
        tableView.reloadData() //2
    }

    // MARK: - Table View Data Source

    /**
    This method is called by the system whenevr the tableView loads its data. It returns the number of sections in the table, which in this case is fixed as 1.
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of rows in a section, which is the number of runs in the array of runs.
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return runs.count
    }

    /**
    This method is called by the system when the data is loaded in the table, it creates a new cell and populates it with the data for a particular run.
    1. Creates a new cell with the identifier runCell, that is of type RunTableViewCell
    2. Gets the run object for the current cell
    3. Sets the labels in the cell to the approriate text, using the stringify methods from the Conversions class
    4. Retrieves the score colour for the current run and sets the background colour of the cell to that colour
    5. Sets the alpha of the progressView to 0.4
    6. Returns the cell
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("runCell", forIndexPath: indexPath) as RunTableViewCell //1
        let run = runs[indexPath.row] //2
        
        cell.distanceLabel.text = Conversions().distanceForInterface(run.distance) //3
        cell.dateLabel.text = run.dateTime.shortDateString()
        cell.paceLabel.text = Conversions().averagePaceForInterface(run.pace)
        cell.durationLabel.text = Conversions().runDurationForInterface(run.duration)
        
        cell.progressView.backgroundColor = run.scoreColour() //4
        cell.progressView.alpha = 0.4; //5
        
        return cell //6
    }

    /**
    This method is called when a user presses the delete button whilst the table is in edit mode.
    1. IF the edit being performed is a delete
            a. Get the run for the row to be deleted
            b. Calls the function deleteRunWithID from the Database class, IF it is successful
                i. Remove the run from the array of runs
               ii. Delete the row from the table view
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { //1
            let run = self.runs[indexPath.row] //a
            if Database().deleteRunWithID(run) { //b
                self.runs.removeAtIndex(indexPath.row) //i
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) //ii
            }
        }
    }
    
    //MARK: - Navigation

    /**
    This method prepares the new view.
    1. Find the indexPath of the selected cell
    2. IF the destinationViewController is a RunDetailsViewController
        a. Set the run of the selected view controller to the run for the selected cell
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "runDetails" {
            if let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell) {
                if let destinationVC = segue.destinationViewController as? RunDetailsViewController {
                    destinationVC.run = runs[selectedIndex.row]
                }
            }
        }
    }
}
