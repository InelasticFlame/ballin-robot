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
    private let stravaClient: StravaClient = DevStravaClient()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.runStore

        self.navigationItem.rightBarButtonItem = self.editButtonItem

        if stravaClient.isAuthorised {
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.addTarget(self, action: #selector(self.loadFromStravaAndRefresh), for: .valueChanged)
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
    @objc func loadFromStravaAndRefresh() {
        let runs = stravaClient.loadRuns()

        for run in runs {
            Database().saveRun(run)
        }

        checkNoRunsLabel()

        finishLoad()
    }

    /**
    This method is called once the runs have been loaded from Strava and stored in the database. It updates the table view with the new runs.
    1. Loads all the runs from the database and stores them in the global array 'runs'
    2. Reloeads the data in the table view
    3. Tells the refresh control to end refreshing
    */
    func finishLoad() {
        self.runStore.source.refresh()
        self.tableView.reloadData() //2
        self.refreshControl?.endRefreshing() //3
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
