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
    
    
    /* */
    var plan: Plan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planDetailsTableView.delegate = self
        planDetailsTableView.dataSource = self
        
        runsMetView.addBorder(1)
        runsMissedView.addBorder(1)
        runsAlmostMetView.addBorder(1)
        runsTotalView.addBorder(1)
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
        
        cell.dateLabel.text = plannedRun.date.shortDateString()
        cell.detailLabel.text = plannedRun.details
        if plannedRun.distance > 0 {
            cell.distanceDurationLabel.text = Conversions().distanceForInterface(plannedRun.distance)
        } else {
            cell.distanceDurationLabel.text = Conversions().runDurationForInterface(plannedRun.duration)
        }
            let match = plannedRun.checkForCompletedRun()
            if match == 0 {
                cell.progressImage.image = UIImage(named: "Cross37px")
            } else if match == 1 {
                cell.progressImage.image = UIImage(named: "Almost37px")
            } else if match == 2 {
                cell.progressImage.image = UIImage(named: "Tick37px")
            }
        }
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? CreatePlanViewController {
            if let plan = plan {
                destinationVC.plan = plan
            }
        }
    }
}
