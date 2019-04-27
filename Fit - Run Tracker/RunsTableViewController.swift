//
//  RunsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 27/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class RunsTableViewController: UITableViewController {
    // MARK: - Global Variables

    private let runStore: StoreTableViewDataSource<RunStore, RunCellFactory> =
        StoreTableViewDataSource(source: RunStore(), reuseIdentifier: "runCell", cellFactory: RunCellFactory())

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.runStore

        self.navigationItem.rightBarButtonItem = self.editButtonItem //1

        NotificationCenter.default.addObserver(self, selector: #selector(RunsTableViewController.finishLoad), name: NSNotification.Name(rawValue: "RunLoadComplete"), object: nil) //2
        NotificationCenter.default.addObserver(self, selector: #selector(RunsTableViewController.loadRuns), name: NSNotification.Name(rawValue: "AuthorisedSuccessfully"), object: nil) //3

        if (UserDefaults.standard.string(forKey: Constants.DefaultsKeys.Strava.AccessTokenKey) ?? "").count > 0 { //4
            self.refreshControl = UIRefreshControl() //a
            self.refreshControl?.addTarget(self, action: #selector(RunsTableViewController.authorise), for: .valueChanged) //b
        }
    }

    /**
    This method is called by the system whenever the view will appear on screen. It reloads the data in the table when the view is about to appear, this ensures that the table is always up to date after further navigation through the app (the view is not reloaded fully each time).
    1. Loads all the runs from the database, storing them in the global array of Run objects, runs
    2. Reloads the tableView
    3. Calls the function checkNoRunsLabel
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.backgroundView = nil

        runStore.source.refresh()
        tableView.reloadData() //2

        checkNoRunsLabel() //3
    }

    /**
    This method is called to check to see if there are any runs stored. If there aren't any, it hides the table view and adds a message telling users how they can add runs.
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
    
    Uses the following local variables:
        noRunsLabel - A UILabel to display if there are no runs
    */
    func checkNoRunsLabel() {
        if runStore.source.count == 0 { //1
            let noRunsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)) //a
            noRunsLabel.text = "No runs available. Either add a run manually or pull down the table to refresh if a Strava Account is linked." //b
            noRunsLabel.textColor = UIColor.darkGray //c
            noRunsLabel.numberOfLines = 0 //d
            noRunsLabel.textAlignment = .center //e
            noRunsLabel.font = UIFont(name: "System", size: 16) //f
            noRunsLabel.sizeToFit() //g
            self.tableView.separatorStyle = .none //h

            self.tableView.backgroundView = noRunsLabel //i
        } else { //2
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
    }

    // MARK: - Run Loading

    /**
    This method calls the function authorise from the StravaAuth class. It is called by the refresh control when a user pulls the table down before the runs are loaded from Strava.
    */
    @objc func authorise() {
        StravaAuth().authorise()
    }

    /**
    This method calls the function loadRunsFromStrava from the StravaRuns classs. It is called after the authorise function has finished (runs cannot be pulled from the Strava server unless the user is authorised first).
    */
    @objc func loadRuns() {
        StravaRuns().loadFromStrava()
    }

    /**
    This method is called once the runs have been loaded from Strava and stored in the database. It updates the table view with the new runs.
    1. Loads all the runs from the database and stores them in the global array 'runs'
    2. Reloeads the data in the table view
    3. Tells the refresh control to end refreshing
    */
    @objc func finishLoad() {
        self.runStore.source.refresh()
        self.tableView.reloadData() //2
        self.refreshControl?.endRefreshing() //3
    }

    // MARK: - Table View Data Source

    /**
    This method is called when a user presses the delete button whilst the table is in edit mode. It removes a run from the table view and also from the database.
    1. IF the edit being performed is a delete
            a. Get the run for the row to be deleted
            b. Calls the function deleteRunWithID from the Database class, IF it is successful
                i. Remove the run from the array of runs
               ii. Delete the row from the table view
              iii. Calls the function checkNoRunsLabel
    
    Uses the following local variables:
        run - The Run object for the current cell
    
    :param: tableView The UITableView that is requesting the insertion of the deletion.
    :param: editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath.
    :param: indexPath The NSIndexPath of the cell that the deletion or insertion is to be performed on.
    */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //1
            let run = runStore.source.get(atIndex: indexPath.row)
            if Database().deleteRun(run) { //b
                runStore.source.remove(atIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade) //ii
                checkNoRunsLabel() //iii
            }
        }
    }

    // MARK: - Navigation

    /**
    This method prepares the new view. It is called by the system whenever is a segue is to be performed.
    1. Find the indexPath of the selected cell
    2. IF the destinationViewController is a RunPageViewController
        a. Set the run of the selected view controller to the run for the selected cell
    
    :param: segue The UIStoryboardSegue containing the information about the view controllers involved in the segue.
    :param: sender The object that caused the segue.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "runDetails" {
            if let selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell) {
                if let destinationVC = segue.destination as? RunPageViewController {
                    destinationVC.run = runStore.source.get(atIndex: selectedIndex.row)
                }
            }
        }
    }
}
