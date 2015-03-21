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
    
    var runs = [Run]() //Creates and initialises a global array of Run objects
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is first loaded
    1. Sets the right button on the navigation bar as an Edit button
    2. Tells the view controller to listen for a notification called "RunLoadComplete", and if it receives the notification to call the function finishLoad
    3. Tells the view controller to listen for a notification called "AuthorisedSuccessfully", and if it receives the notification to call the function loadRuns
    4. Retrieves the string from the user defaults with the access token key, IF it's character count is greater than 0
        a. Creates and sets the refresh control for the table
        b. Tells the refresh control to call the function authorise when it is used
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem() //1
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishLoad", name: "RunLoadComplete", object: nil) //2
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadRuns", name: "AuthorisedSuccessfully", object: nil) //3
        
        if NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.Strava.AccessTokenKey)?.utf16Count > 0 { //4
            self.refreshControl = UIRefreshControl() //a
            self.refreshControl?.addTarget(self, action: "authorise", forControlEvents: .ValueChanged) //b
        }
    }
    
    /**
    This method reloads the data in the table when the view is about to appear, this ensures that the table is always up to date after further navigation through the app (the view is not reloaded fully each time)
    1. Loads all the runs from the database, storing them in the global array of Run objects, runs
    2. Reloads the tableView
    3. Calls the function checkNoRunsLabel
    */
    override func viewWillAppear(animated: Bool) {
        self.tableView.backgroundView = nil
        
        self.runs = Database().loadRunsWithQuery("") as Array<Run> //1
        tableView.reloadData() //2
        
        checkNoRunsLabel() //3
    }
    
    /**
    1. IF there are no runs
        a. Creates a new label that is the size of the screen
        b. Sets the text of the label
        c. Sets the text colour to dark gray
        d. Sets the number of lines to 0; this tells the label to use as many lines as needed to fit all the text on
        e. Sets the text to align center
        f. Sets the font to the system font of size 16
        g. Sizes the label to fix the view
        h. Removes the separators from the table view
        i. Sets the background of the table view to the created label
    2. ELSE removes the background view (if there is one) and sets the separator style to single line
    */
    func checkNoRunsLabel() {
        if runs.count == 0 { //1
            let noRunsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)) //a
            noRunsLabel.text = "No runs available. Either add a run manually or pull down the table to refresh if a Strava Account is linked." //b
            noRunsLabel.textColor = UIColor.darkGrayColor() //c
            noRunsLabel.numberOfLines = 0 //d
            noRunsLabel.textAlignment = .Center //e
            noRunsLabel.font = UIFont(name: "System", size: 16) //f
            noRunsLabel.sizeToFit() //g
            self.tableView.separatorStyle = .None //h
            
            self.tableView.backgroundView = noRunsLabel //i
        } else { //2
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .SingleLine
        }
    }
    
    
    //MARK: - Run Loading
    
    /**
    This method calls the function authorise from the StravaAuth class. It is called by the refresh control when a user pulls the table down before the runs are loaded from Strava.
    */
    func authorise() {
        StravaAuth().authorise()
    }
    
    /**
    This method calls the function loadRunsFromStrava from the StravaRuns classs. It is called after the authorise function has finished (runs cannot be pulled from the Strava server unless the user is authorised first).
    */
    func loadRuns() {
        StravaRuns().loadRunsFromStrava()
    }
    
    /**
    This method is called once the runs have been loaded from Strava and stored in the database.
    1. Loads all the runs from the database and stores them in the global array 'runs'
    2. Reloeads the data in the table view
    3. Tells the refresh control to end refreshing
    */
    func finishLoad() {
        self.runs = Database().loadRunsWithQuery("") as Array<Run> //1
        self.tableView.reloadData() //2
        self.refreshControl?.endRefreshing() //3
    }

    // MARK: - Table View Data Source

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of sections in the table, which in this case is fixed as 1.
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
    3. Sets the labels in the cell to the appropriate text, using the stringify methods from the Conversions class
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
              iii. Calls the function checkNoRunsLabel
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { //1
            let run = self.runs[indexPath.row] //a
            if Database().deleteRunWithID(run) { //b
                self.runs.removeAtIndex(indexPath.row) //i
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) //ii
                checkNoRunsLabel() //iii
            }
        }
    }
    
    //MARK: - Navigation

    /**
    This method prepares the new view.
    1. Find the indexPath of the selected cell
    2. IF the destinationViewController is a RunPageViewController
        a. Set the run of the selected view controller to the run for the selected cell
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "runDetails" {
            if let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell) {
                if let destinationVC = segue.destinationViewController as? RunPageViewController {
                    destinationVC.run = runs[selectedIndex.row]
                }
            }
        }
    }
}
