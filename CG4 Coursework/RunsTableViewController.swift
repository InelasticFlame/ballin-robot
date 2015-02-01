//
//  RunsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 27/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class RunsTableViewController: UITableViewController {
    
    var runs = [Run]() //Creates and inititalises a global array of Run objects
    
    /**
    This method:
    1. Loads all the runs from the database
    2. Sets the right button on the navigation bar as an Edit button
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.runs = Database().loadRunsWithQuery("") as Array<Run>

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    /**
    This method reloads the data in the table when the view appears, this ensures that all views are correctly formatted as all constraits have been fully updated.
    */
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

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
    2. Sets the labels in the cell to the approriate text, using the stringify methods from the Conversions class
    3. Calls the function returnScoreColour from the Conversions class, passing the run for the current cell, setting the background of the progressView to the returned colour
    4. Sets the alpha of the progressView to 0.4
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("runCell", forIndexPath: indexPath) as RunTableViewCell
        
        cell.distanceLabel.text = Conversions().distanceForInterface(runs[indexPath.row].distance)
        cell.dateLabel.text = Conversions().dateToString(runs[indexPath.row].dateTime)
        cell.paceLabel.text = Conversions().averagePaceForInterface(runs[indexPath.row].pace)
        cell.durationLabel.text = Conversions().runDurationForInterface(runs[indexPath.row].duration)
        
        cell.progressView.backgroundColor = Conversions().returnScoreColour(runs[indexPath.row])
        cell.progressView.alpha = 0.4;
        
        return cell
    }

    /**
    This method is called when a user presses the delete button whilst the table is in edit mode.
    1. IF the edit being performed is a delete
        a. Create an alert titled "Delete run?" with the message "Deleting this run will permanently remove it." and 2 buttons, a Delete button and a Cancel button
        b. When the Delete button is pressed
            i. Get the run for the row to be deleted
           ii. Calls the function deleteRunWithID from the Database class, IF it is successful
              iii. Remove the run from the array of runs
               iv. Delete the row from the table view
            v. Dismiss the alrt
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { //1
            let alert = UIAlertController(title: "Delete run?", message: "Deleting this run will permanently remove it.", preferredStyle: UIAlertControllerStyle.Alert) //a
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { action in
                /* Block Start */
                //b
                let run = self.runs[indexPath.row] //i
                if Database().deleteRunWithID(run) { //ii
                    self.runs.removeAtIndex(indexPath.row) //iii
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) //iv
                }
                self.dismissViewControllerAnimated(true, completion: nil) //v
                /* Block End */
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
            let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell)
            
            if let destinationVC = segue.destinationViewController as? RunDetailsViewController {
                destinationVC.run = runs[selectedIndex!.row]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
