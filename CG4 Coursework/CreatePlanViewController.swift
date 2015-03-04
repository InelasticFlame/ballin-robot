//
//  CreatePlanViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 16/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myNavigationItem: UINavigationItem!
    @IBOutlet weak var plannedRunsTableView: UITableView!
    
    var plan: Plan?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let plan = self.plan {
            println("Plan \(plan.name)")
        }
        
        self.navigationItem.hidesBackButton = true
        
        plannedRunsTableView.dataSource = self
        plannedRunsTableView.delegate = self
        
        myNavigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        plan?.loadPlannedRuns()
        plannedRunsTableView.reloadData()
    }
    
    //MARK: - Editing
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        plannedRunsTableView.setEditing(editing, animated: animated)
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
        
        cell.dateLabel.text = plannedRun?.date.shortestDateString()
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let plan = plan {
                if Database().deletePlannedRun(plan.plannedRuns[indexPath.row]) {
                    plan.plannedRuns.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
        }
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
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
