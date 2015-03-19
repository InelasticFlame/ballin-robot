//
//  AddRunTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 02/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddRunTableViewController: UITableViewController {
    
    //MARK: - Storyboard Links
    
    @IBOutlet weak var runDatePicker: UIDatePicker!
    @IBOutlet weak var runDistancePicker: DistancePicker!
    @IBOutlet weak var runPacePicker: PacePicker!
    @IBOutlet weak var runDurationPicker: DurationPicker!
    @IBOutlet weak var runShoePicker: ShoePicker!
    @IBOutlet weak var runDateDetailLabel: UILabel!
    @IBOutlet weak var runDistanceDetailLabel: UILabel!
    @IBOutlet weak var runPaceDetailLabel: UILabel!
    @IBOutlet weak var runDurationDetailLabel: UILabel!
    @IBOutlet weak var runShoeDetailLabel: UILabel!
    
    //MARK: - Global Variables
    private var indexPathToShow: NSIndexPath?
    private var lastPicker = ""
    private var currentPicker = ""
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDetailLabels(nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDetailLabels:", name: "UpdateDetailLabel", object: nil)
    }

    // MARK: - Table View Data Source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return Constants.TableView.DefaultRowHeight
        } else {
            if indexPathToShow == indexPath {
                return Constants.TableView.PickerRowHeight
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
            tableView.reloadTableViewCells()
            indexPathToShow = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadTableViewCells()
    }
    
    func updateDetailLabels(notification: NSNotification?) {
        if let notification = notification {
            checkRunValues(notification)
        }
        runDateDetailLabel.text = runDatePicker.date.shortDateString()
        runDistanceDetailLabel.text = runDistancePicker.selectedDistance().distanceStr
        runPaceDetailLabel.text = runPacePicker.selectedPace().paceStr
        runDurationDetailLabel.text = runDurationPicker.selectedDuration().durationStr
        if let shoe = runShoePicker.selectedShoe() {
            runShoeDetailLabel.text = shoe.name
        } else {
            runShoeDetailLabel.text = "None"
        }
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
            
            if (currentPicker == "DISTANCE" || currentPicker == "PACE") && (lastPicker == "DISTANCE" && lastPicker == "PACE") {
                if runPace != 0 && runDistance != 0  {
                    let newDuration = Int(runDistance * Double(runPace))
                    runDurationPicker.setDuration(newDuration)
                }
            } else if (currentPicker == "DISTANCE" || currentPicker == "DURATION") && (lastPicker == "DISTANCE" && lastPicker == "DURATION") {
                if runDuration != 0 && runDistance != 0  {
                    let newPace = Int(Double(runDuration) / runDistance)
                    runPacePicker.setPace(newPace)
                }
            } else if (currentPicker == "PACE" || currentPicker == "DURATION") && (lastPicker == "PACE" && lastPicker == "DURATION") {
                if runDuration != 0 && runPace != 0  {
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
        let selectedShoe: Shoe? = runShoePicker.selectedShoe()
        
        if runDistance > 0 && runPace > 0 && runDuration > 0 {
            let run = Run(runID: 0, distance: runDistance, dateTime: runDatePicker.date, pace: runPace, duration: runDuration, shoe: selectedShoe, runScore: 0, runLocations: nil, runType: "Run", splits: nil)
            run.calculateRunScore()
            Database().saveRun(run)
            Database().increaseShoeMiles(selectedShoe, byAmount: runDistance)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let error = "At least 2 from distance, pace and duration must have been input."
            let alert = UIAlertController(title: "Invalid Run", message: error, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
