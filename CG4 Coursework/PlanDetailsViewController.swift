//
//  PlanDetailsViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 07/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PlanDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    
    /* */
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
            let match = plannedRun.checkForCompletedRun()
            if match.rank == 0 {
                cell.progressImage.image = UIImage(named: "Cross37px")
                cell.accessoryType = .None
                cell.selectionStyle = .None
                missedRuns += 1
                runsMissedLabel.text = "\(missedRuns)"
            } else if match.rank == 1 {
                cell.progressImage.image = UIImage(named: "Almost37px")
                almostMetRuns += 1
                runsAlmostMetLabel.text = "\(almostMetRuns)"
            } else if match.rank == 2 {
                cell.progressImage.image = UIImage(named: "Tick37px")
                metRuns += 1
                runsMetLabel.text = "\(metRuns)"
            }
            cell.matchingRun = match.run
        }
        return cell
    }
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let cell = sender as? PlanDetailsTableViewCell {
            if let matchingRun = cell.matchingRun {
                return true
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
        
        if let destinationVC = segue.destinationViewController as? RunDetailsViewController {
            if let cell = sender as? PlanDetailsTableViewCell {
                if let run = cell.matchingRun {
                    cell.selected = false
                    destinationVC.run = run
                }
            }
        }
    }
}
