//
//  PlanDetailsViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 07/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PlanDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Storyboard Links
    
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
    
    
    //MARK: - Global Variables
    var plan: Plan?
    var metRuns = 0
    var almostMetRuns = 0
    var missedRuns = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planDetailsTableView.delegate = self
        planDetailsTableView.dataSource = self
        
        runsMetView.addBorder(1)
        runsMissedView.addBorder(1)
        runsAlmostMetView.addBorder(1)
        runsTotalView.addBorder(1)
        
        if let plan = plan {
            runsPlannedLabel.text = "\(plan.plannedRuns.count)"
            for plannedRun in plan.plannedRuns {
                if plannedRun.matchRank == 0 {
                    missedRuns += 1
                } else if plannedRun.matchRank == 1 {
                    almostMetRuns += 1
                } else if plannedRun.matchRank == 2 {
                    metRuns += 1
                }
            }
            runsMissedLabel.text = "\(missedRuns)"
            runsAlmostMetLabel.text = "\(almostMetRuns)"
            runsMetLabel.text = "\(metRuns)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let plan = plan {
            return plan.plannedRuns.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlanDetails", forIndexPath: indexPath) as PlanDetailsTableViewCell
        if let plannedRun = plan?.plannedRuns[indexPath.row] {
            
            cell.dateLabel.text = plannedRun.date.shortestDateString()
            cell.detailLabel.text = plannedRun.details
            
            if plannedRun.distance > 0 {
                cell.distanceDurationLabel.text = Conversions().distanceForInterface(plannedRun.distance)
            } else {
                cell.distanceDurationLabel.text = Conversions().runDurationForInterface(plannedRun.duration)
            }
            
            if plannedRun.matchRank == 0 {
                cell.progressImage.image = UIImage(named: "Cross37px")
                cell.accessoryType = .None
                cell.selectionStyle = .None
            } else if plannedRun.matchRank == 1 {
                cell.progressImage.image = UIImage(named: "Almost37px")
            } else if plannedRun.matchRank == 2 {
                cell.progressImage.image = UIImage(named: "Tick37px")
            } else if plannedRun.matchRank == 3 {
                cell.accessoryType = .None
                cell.selectionStyle = .None
                cell.progressImage.image = nil
            }
        }
        return cell
    }
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let cell = sender as? PlanDetailsTableViewCell { //CHECK IF THERE IS A PLANNED RUN
            if let indexPath = planDetailsTableView.indexPathForCell(cell) {
                if let plannedRun = plan?.plannedRuns[indexPath.row].matchingRun {
                    return true
                }
            }
        } else if identifier == "edit" {
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? CreatePlanViewController {
            if let plan = plan {
                destinationVC.plan = plan
            }
        }
        
        if let destinationVC = segue.destinationViewController as? RunPageViewController {
            if let cell = sender as? PlanDetailsTableViewCell {
                if let indexPath = planDetailsTableView.indexPathForCell(cell) {
                    if let plannedRun = plan?.plannedRuns[indexPath.row].matchingRun {
                        destinationVC.run = plannedRun
                        cell.selected = false
                    }
                }
            }
        }
    }
}
