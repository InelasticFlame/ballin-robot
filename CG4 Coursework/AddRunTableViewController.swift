//
//  AddRunTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 02/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddRunTableViewController: UITableViewController {
    
    @IBOutlet weak var runDatePicker: UIDatePicker!
    @IBOutlet weak var runDistancePicker: DistancePicker!
    @IBOutlet weak var runPacePicker: PacePicker!
    @IBOutlet weak var runDurationPicker: DurationPicker!
    @IBOutlet weak var runShoePicker: UIPickerView!
    
    @IBOutlet weak var runDateDetailLabel: UILabel!
    @IBOutlet weak var runDistanceDetailLabel: UILabel!
    @IBOutlet weak var runPaceDetailLabel: UILabel!
    @IBOutlet weak var runDurationDetailLabel: UILabel!
    @IBOutlet weak var runShoeDetailLabel: UILabel!
    
    
    
    private let pickerRowHeight: CGFloat = 162
    private let defaultRowHeight: CGFloat = 44
    
    private var indexPathToShow: NSIndexPath?
    private var lastPicker = ""
    private var currentPicker = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDetailLabels(nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDetailLabels:", name: "UpdateDetailLabel", object: nil)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return defaultRowHeight
        } else {
            if indexPathToShow == indexPath {
                return pickerRowHeight
            } else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPathToShow == NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section) {
            indexPathToShow = nil
        } else {
            indexPathToShow = nil
            reloadTableViewCells()
            indexPathToShow = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        reloadTableViewCells()
    }
    
    func reloadTableViewCells() {
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func updateDetailLabels(notification: NSNotification?) {
        if let notification = notification {
            checkRunValues(notification)
        }
        runDateDetailLabel.text = runDatePicker.date.shortDateString()
        runDistanceDetailLabel.text = runDistancePicker.selectedDistance().distanceStr
        runPaceDetailLabel.text = runPacePicker.selectedPace().paceStr
        runDurationDetailLabel.text = runDurationPicker.selectedDuration().durationStr
//        runShoeDetailLabel.text = runShoePicker.selectedShoe().name
    }
    
    func checkRunValues(notification: NSNotification) {
        /*
        In this case the system assumes that the last used picker and the current picker are correct values, and so the other picker should be calculated.
        */
        let runDistance = runDistancePicker.selectedDistance().distance
        let runPace = runPacePicker.selectedPace().pace
        let runDuration = runDurationPicker.selectedDuration().duration
        let userInfo = notification.userInfo as NSDictionary?
        
        if let userInfo = userInfo {
            let valueChanged = userInfo.objectForKey("valueChanged") as String
            
            if valueChanged != currentPicker {
                lastPicker = currentPicker
                currentPicker = valueChanged
            }
            
            if currentPicker == "DISTANCE" {
                if lastPicker == "PACE" {
                    let newDuration = Int(runDistance * Double(runPace))
                    runDurationPicker.setDuration(newDuration)
                } else if lastPicker == "DURATION" {
                    let newPace = Int(Double(runDuration) / runDistance)
                    runPacePicker.setPace(newPace)
                }
            } else if currentPicker == "PACE" {
                if lastPicker == "DISTANCE" {
                    let newDuration = Int(runDistance * Double(runPace))
                    runDurationPicker.setDuration(newDuration)
                } else if lastPicker == "DURATION" {
                    let newDistance = Double(runDuration) / Double(runPace)
                    runDistancePicker.setDistance(newDistance)
                }
            } else if currentPicker == "DURATION" {
                if lastPicker == "DISTANCE" {
                    let newPace = Int(Double(runDuration) / runDistance)
                    runPacePicker.setPace(newPace)
                } else if lastPicker == "PACE" {
                    let newDistance = Double(runDuration) / Double(runPace)
                    runDistancePicker.setDistance(newDistance)
                }
            }
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let runDistance = runDistancePicker.selectedDistance().distance
        let runPace = runPacePicker.selectedPace().pace
        let runDuration = runDurationPicker.selectedDuration().duration
        
        if runDistance > 0 && runPace > 0 && runDuration > 0 {
            let run = Run(runID: 0, distance: runDistance, dateTime: runDatePicker.date, pace: runPace, duration: runDuration, shoe: nil, runScore: 0, runLocations: nil, runType: "Run", splits: nil)
            run.calculateRunScore()
            Database().saveRun(run)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let error = "At least 2 from distance, pace and duration must be input."
            let alert = UIAlertController(title: "Invalid Run", message: error, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
