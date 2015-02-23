//
//  CreatePlanViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 16/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var plannedRunsTableView: UITableView!
    
    var plan: Plan?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let plan = self.plan {
            println("Plan \(plan.name)")
        }
        
        plannedRunsTableView.dataSource = self
        plannedRunsTableView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        plan?.loadPlannedRuns()
        plannedRunsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Data Source
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
        let cell = tableView.dequeueReusableCellWithIdentifier("PlannedRun", forIndexPath: indexPath) as PlannedRunTableViewCell
        let plannedRun = plan?.plannedRuns[indexPath.row]
        
        cell.dateLabel.text = plannedRun?.date.shortDateString()
        cell.detailsLabel.text = plannedRun?.details
        if plannedRun?.distance > 0 {
            cell.distanceDurationLabel.text = Conversions().distanceForInterface(plannedRun!.distance)
        } else {
            cell.distanceDurationLabel.text = Conversions().runDurationForInterface(plannedRun!.duration)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? NewPlannedRunTableViewController {
            if let plan = plan {
                destinationVC.plan = plan
            }
        }
    }
}
