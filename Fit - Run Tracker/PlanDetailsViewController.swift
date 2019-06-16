//
//  PlanDetailsViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 07/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PlanDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Storyboard Links

    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var planDetailsTableView: UITableView!
    @IBOutlet weak var runsMetView: UIView!
    @IBOutlet weak var runsMissedView: UIView!
    @IBOutlet weak var runsAlmostMetView: UIView!
    @IBOutlet weak var runsTotalView: UIView!
    @IBOutlet weak var runsMetLabel: UILabel!
    @IBOutlet weak var runsAlmostMetLabel: UILabel!
    @IBOutlet weak var runsMissedLabel: UILabel!
    @IBOutlet weak var runsPlannedLabel: UILabel!

    // MARK: - Global Variables
    var plan: Plan? //A global plan object variable that stores the plan being shown on the view
    var metRuns = 0 //A global integer variable that stores the number of runs met in the plan
    var almostMetRuns = 0 //A global integer variable that stores the number of runs almost met in the plan
    var missedRuns = 0 //A global integer variable that stores the number of runs missed in the plan

    // MARK: - View Life Cycle

    /**
    This method is called by the system when the view is initially loaded.
    1. Sets the delegate (controller) and the datasource of the planDetailsTableView to this view controller
    2. Adds a border to the runsMetView, runsMissedView, runsAlmostMetView and runsTotalView
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        planDetailsTableView.delegate = self //1
        planDetailsTableView.dataSource = self

        runsMetView.addBorder(borderWidth: 1) //2
        runsMissedView.addBorder(borderWidth: 1)
        runsAlmostMetView.addBorder(borderWidth: 1)
        runsTotalView.addBorder(borderWidth: 1)
    }

    /**
    This method is called by the system whenever the view is about appear on screen.
    1. Calls the function loadPlannedRuns on the current plan
    2. Reloads the data in the planDetailsTableView
    3. IF there is a plan
        a. Sets the value of missedruns, almostMetRuns and metRuns to 0
        b. For each plannedRun in the plan's plannedRuns array
            i. IF the plannedRun has a matchRank of 0
                Z. Increase the number of missedRuns by 1
           ii. ELSE IF the plannedRun has a matchRank of 1
                Y. Increase the number of almostMetRuns by 1
          iii. ELSE IF the plannedRun has a matchRank of 2
                x. Increase the number of metRuns by 1
        c. Sets the text of the runsPlannedLabel to the number of plannedRuns
        d. Sets the text of the runsMissedLabel to the number of runs missed
        e. Sets the text of the runsAlmostMetLabel to the number of runsAlmostMet
        f. Sets the text of the runsMetLabel to the number of metRuns
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        plan?.loadPlannedRuns() //1
        planDetailsTableView.reloadData() //2
        if let plan = plan { //3
            missedRuns = 0 //a
            almostMetRuns = 0
            metRuns = 0

            for plannedRun in plan.plannedRuns { //b
                if plannedRun.matchRank == 0 { //i
                    missedRuns += 1 //Z
                } else if plannedRun.matchRank == 1 { //ii
                    almostMetRuns += 1 //Y
                } else if plannedRun.matchRank == 2 { //iii
                    metRuns += 1 //X
                }
            }

            runsPlannedLabel.text = "\(plan.plannedRuns.count)" //c
            runsMissedLabel.text = "\(missedRuns)" //d
            runsAlmostMetLabel.text = "\(almostMetRuns)" //e
            runsMetLabel.text = "\(metRuns)" //f
        }
    }

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of sections in the table, which in this case is fixed as 1.
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :returns: An integer value that is the number of sections in the table view.
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of rows in a section, which is the number of runs in the array of plannedRuns. IF there is no plan then it is 0
    
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
    This method is called by the system when the data is loaded in the table, it creates a new cell and populates it with the data for a particular planned run.
    1. Creates a new cell with the identifier PlanDetails, that is of type PlanDetailsTableViewCell
    2. IF there is a plannedRun for the current cell
        a. Set the dateLabel text to the plannedRun date as a shortestDateString()
        b. Sets the detailLabel text to the plannedRun details
        c. IF the runDistance is greater than 0
            i. Sets the distanceDurationLabel text to the plannedRun distance converted using the conversions class
        d. ELSE
            i. Sets the distanceDurationLabel text to the plannedRun duration converted using the conversions class
        e. IF the plannedRun matchRank is 0
            i. Sets the progressImage to the Image called "Cross37px"
           ii. Sets the selection style and accessoryType of the cell to None
        f. ELSE IF the plannedRun matchRank is 1
            i. Sets the progressImage to the image called "Almost37px"
           ii. Sets the cell accessory to a disclosure indicator
        g. ELSE IF the plannedRun matchRank is 2
            i. Sets the progressImage to the image called "Tick37px"
           ii. Sets the cell accessory to a disclosure indicator
        h. ELSE IF the plannedRun matchRank is -1
            i. Sets the accessoryType and selectionType of the cell to None
           ii. Sets the progressImage to the image called "FutureRun37px"
    3. Returns the cell
    
    :param: tableView The UITableView that is requesting the cell.
    :param: indexPath The NSIndexPath of the cell requested.
    :returns: The UITableViewCell for the indexPath.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanDetails", for: indexPath as IndexPath) as! PlanDetailsTableViewCell //1
        if let plannedRun = plan?.plannedRuns[indexPath.row] { //2

            cell.dateLabel.text = plannedRun.date.toShortestDateString //a
            cell.detailLabel.text = plannedRun.details //b

            if plannedRun.distance > 0.miles { //c
                // TODO: should check what the display unit is
                cell.distanceDurationLabel.text = plannedRun.distance.toString(Miles.unit)
            } else { //d
                cell.distanceDurationLabel.text = Conversions().runDurationForInterface(duration: Int(plannedRun.duration.rawValue)) //i
            }

            if plannedRun.matchRank == 0 { //e
                cell.progressImage.image = UIImage(named: "Cross37px") //i
                cell.accessoryType = .none //ii
                cell.selectionStyle = .none
            } else if plannedRun.matchRank == 1 { //f
                cell.progressImage.image = UIImage(named: "Almost37px") //i
                cell.accessoryType = .disclosureIndicator //ii
            } else if plannedRun.matchRank == 2 { //g
                cell.progressImage.image = UIImage(named: "Tick37px") //i
                cell.accessoryType = .disclosureIndicator //ii
            } else if plannedRun.matchRank == -1 { //h
                cell.accessoryType = .none //i
                cell.selectionStyle = .none
                cell.progressImage.image = UIImage(named: "FutureRun37px") //ii
            }
        }
        return cell //3
    }

    // MARK: - Navigation

    /**
    This method is called by the system to check if a segue should be performed. It checks to see if a planned run does have a matching run, if it doens't the segue shouldn't be performed.
    1. IF the source of the segue is a PlanDetailsTableViewCell
        a. IF the indexPath for the cell can be retrieved
            i. IF there is matchingRun for the cell's row
                ii. Return true
    2. ELSE IF the segue to be performed has identifier "edit"
        b. Return true
    3. In the default case return false
    
    :param: identifier The string that identifies the triggered segue.
    :param: sender The object that initiated the segue.
    :returns: A boolean value indicating whether the segue should be performed.
    */
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let cell = sender as? PlanDetailsTableViewCell { //1
            if let indexPath = planDetailsTableView.indexPath(for: cell) { //a
                if (plan?.plannedRuns[indexPath.row].matchingRun) != nil { //i
                    return true //ii
                }
            }
        } else if identifier == "edit" { //2
            return true //b
        }

        return false //3
    }

    /**
    This method is called by the system when a segue is about to be performed. It is used to prepare the new view.
    1. IF the destination view controller is a CreatePlanViewController
        a. IF there is a plan
            i. Set the plan of the destinationVC to the plan
    2. IF the destination view controller is a RunPageViewController
        a. IF the source of the segue is a PlanDetailsTableViewCell
            i. IF the indexPath for the cell can be retrieved
                ii. IF there is matchingRun for the cell's row
                  iii. Set the run of the destination view controller to the matching run
                   iv. Set the cell's selection state to false
    
    :param: segue The UIStoryboardSegue containing the information about the view controllers involved in the segue.
    :param: sender The object that caused the segue.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CreatePlanViewController { //1
            if let plan = plan { //a
                destinationVC.plan = plan //b
            }
        }

        if let destinationVC = segue.destination as? RunPageViewController { //2
            if let cell = sender as? PlanDetailsTableViewCell { //a
                if let indexPath = planDetailsTableView.indexPath(for: cell) { //i
                    if let matchingRun = plan?.plannedRuns[indexPath.row].matchingRun { //ii
                        destinationVC.run = matchingRun //iii
                        cell.isSelected = false //iv
                    }
                }
            }
        }
    }
}
