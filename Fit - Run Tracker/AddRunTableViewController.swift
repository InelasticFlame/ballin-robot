//
//  AddRunTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 02/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddRunTableViewController: UITableViewController {

    // MARK: - Storyboard Links

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

    // MARK: - Global Variables
    private var indexPathToShow: IndexPath? //A global IndexPath variable that stores the index path of the cell with a picker view that is currently to be displayed
    private var lastPicker = "" //A global string variable that stores the last picker used, this is used to know which pickers to use in calculations
    private var currentPicker = "" //A global string variable that stores the picker currently being used, this is used to know which pickers to use in calculations

    // MARK: - View Life Cycle

    /**
    This method is called by the system when the view is initially loaded. It configures the view ready for display on the interface.
    1. Calls the function updateDetailLabels, passing nil (as there is no NSNotification)
    2. Tells the view to listen for the notification UpdateDetailLabel; when it receives this notification it should call the function updateDetailLabels (the system will also pass the dictionary passed along with the notification)
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        updateDetailLabels(notification: nil) //1
        NotificationCenter.default.addObserver(self, selector: #selector(AddRunTableViewController.updateDetailLabels), name: NSNotification.Name(rawValue: "UpdateDetailLabel"), object: nil) //2
    }

    // MARK: - Table View Data Source

    /**
    This method is called by the system whenever the data is loaded in the table view. It returns the height for a cell at a specified index path.
    1. IF the indexPath is an EVEN number
        a. Return the default row height
    2. ELSE
        b. IF the indexPathToShow is the current indexPath
            i. Return the picker row height
        c. ELSE return 0
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: indexPath The NSIndexPath of the row that's height is being requested.
    :returns: A CGFloat value that is the rows height.
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 { //1
            return Constants.TableView.DefaultRowHeight //a
        } else { //2
            if indexPathToShow == indexPath { //b
                return Constants.TableView.PickerRowHeight //i
            } else { //c
                return 0
            }
        }
    }

    /**
    This method is called by the system whenever a user selects a row in the table view. It works out which cells to hide and which cells to display on the interface based on which cell a user has clicked.
    1. IF the indexPath to show is one more than the current row (i.e. the picker being shown is the one below this cell -> user has clicked the same cell again -> so set indexPathToShow to nil to hide the picker)
    2. ELSE
        a. Set the indexPathToShow to nil
        b. Calls the function reloadTableViewCells (hide the old picker)
        c. Sets the indexPathToShow to be one more than the selectedIndexPath
    3. Deselects the selected cell, animating the transition
    4. Calls the function reloadTableViewCells (show the new picker if there is one)
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPathToShow == IndexPath(row: indexPath.row + 1, section: indexPath.section) { //1
            indexPathToShow = nil //a
        } else { //2
            indexPathToShow = nil //b
            tableView.reloadTableViewCells() //c
            indexPathToShow = IndexPath(row: indexPath.row + 1, section: indexPath.section) //d
        }

        tableView.deselectRow(at: indexPath as IndexPath, animated: true) //3
        tableView.reloadTableViewCells() //4
    }

    // MARK: - Update Interface

    /**
    This method is initially called when the view loads and then called whenever the view controller receives the notification UpdateDetailLabel. It updates the text of the detail labels in the table view.
    1. IF there is a notification (i.e. any time when the method is called other than when the view initially loads)
        a. Call the function checkRunValues passing the notification
    2. Sets the runDateDetailLabel text to the date selected in the runDatePicker as a shortDateString
    3. Sets the runDistanceDetailLabel text to the runDistancePicker selectedDistance as a string
    4. Sets the runPaceDetailLabel text to the runPacePicker selectedPace as a string
    5. Sets the runDurationDetailLabel text to the runDurationPicker selected duration as a string
    6. IF there is a shoe selected
        b. Sets the runShoeDetailLabel text as the shoe name
    7. ELSE sets the runShoeDetailLabel to None
    
    :param: notification The NSNotification which called the method.
    */
    @objc func updateDetailLabels(notification: NSNotification?) {
        if let notification = notification { //1
            checkRunValues(notification: notification) //a
        }
        runDateDetailLabel.text = runDatePicker.date.toShortDateString
        runDistanceDetailLabel.text = runDistancePicker.selectedDistance().distanceStr //3
        runPaceDetailLabel.text = runPacePicker.selectedPace().paceStr //4
        runDurationDetailLabel.text = runDurationPicker.selectedDuration().durationStr //5
        if let shoe = runShoePicker.selectedShoe() { //6
            runShoeDetailLabel.text = shoe.name //b
        } else { //7
            runShoeDetailLabel.text = "None"
        }
    }

    /**
    This method is called by the updateDetailLabels methoed whenever the view recieves the notification "UpdateDetailLabel". It checks that the values selected in the pickers make sense (i.e. a run has the correct pace for a given distance and duration).
    1. Declares and initialises the local variables runDistance, runPace, runDuration, and userInfo
    2. IF there is userInfo (a dictionary passed with the notification)
        a. Retrieve the pickerValueChanged as the object stored with the key "valueChanged"
        b. IF the pickerValueChanged is not the same as the currentPicker
            i. Sets the lastPicker to the currentPicker
           ii. Sets the currentPicker to the pickerValueChanged
        c. IF the currentPicker is DISTANCE or PACE and the lastPicker is DISTANCE or PACE (in this case we can calculate the runDuration)
          iii. Calculate the new duration as the runDistance * runPace
           iv. Set the runDurationPicker's duration to the newDuration
        d. ELSE IF the currentPicker is DISTANCE or DURATION and the lastPicker is DISTANCE or DURATION (in this case we can calculate the runPace)
            v. Calculate the new pace as the integer value of the runDuration divided by the runDistance
           vi. Sets the value of the runPacePicker to the newPace
        e. ELSE IF the currentPicker is PACE or DURATION and the lastPicker is PACE or DURATION (in this case we can calculate the run distance)
          vii. Calculate the new distance as the duration divided by the pace as a double
         viii. Sets the value of the runDistancePicker to the newDistance
    
    Uses the following local variables:
        runDistance - A constant double that is the distance selected using the runDistancePicker
        runPace - A constant integer that is the pace selected using the runPacePicker
        runDuration - A constant integer that is the duration selected using the runDurationPicker
        userInfo - A constant NSDictionary that stores the userInfo from the notification
    
    :param: notification The NSNotification which called the method.
    */
    func checkRunValues(notification: NSNotification) {
        /*
        In this case the system assumes that the last used picker and the current picker are correct values, and so the other picker should be calculated.
        */
        let runDistance = runDistancePicker.selectedDistance().distance //1
        let runPace = runPacePicker.selectedPace().pace
        let runDuration = runDurationPicker.selectedDuration().duration
        let userInfo = notification.userInfo as NSDictionary?

        if let userInfo = userInfo { //2
            let pickerValueChanged = userInfo.object(forKey: "valueChanged") as! String //a

            if pickerValueChanged != currentPicker { //b
                lastPicker = currentPicker //i
                currentPicker = pickerValueChanged //ii
            }

            if (currentPicker == "DISTANCE" || currentPicker == "PACE") && (lastPicker == "DISTANCE" || lastPicker == "PACE") { //c
                if runPace != 0 && runDistance != 0 { //(Checks the values aren't 0 as a user may have set them to 0)
                    let newDuration = Int(runDistance.rawValue * Double(runPace)) //iii
                    runDurationPicker.setDuration(duration: newDuration) //iv
                }
            } else if (currentPicker == "DISTANCE" || currentPicker == "DURATION") && (lastPicker == "DISTANCE" || lastPicker == "DURATION") { //d
                if runDuration != 0 && runDistance != 0 { //(Checks the values aren't 0 as a user may have set them to 0)
                    let newPace = Int(Double(runDuration) / runDistance.rawValue) //v
                    runPacePicker.setPace(pace: newPace) //vi
                }
            } else if (currentPicker == "PACE" || currentPicker == "DURATION") && (lastPicker == "PACE" || lastPicker == "DURATION") {
                if runDuration != 0 && runPace != 0 { //(Checks the values aren't 0 as a user may have set them to 0)
                    let newDistance = Double(runDuration) / Double(runPace) //vii
                    runDistancePicker.setDistance(distance: newDistance) //viii
                }
            }
        }
    }

    // MARK: - Save Run

    /**
    This method is called by the system when the user presses the Done button. It validates the run and saves into the database.
    1. Declares and initialises the local variables runDistance, runPace, runDuration, and selectedShoe
    2. IF the runDistance, runPace and runDuration are all > 0
        a. Create the run object using the values selected on the interface
        b. Calculates the runScore
        c. Calls the function saveRun from the Database class passing the run
        d. Calls the function increaseShoeMiles from the Database class passisng the selectedShoe and the runDistance
        e. Dismisses the view controller
    3. ELSE
        f. Creates the error text
        g. Creates a UIAlert to display the error message with the title "Invalid Run"
        h. Add an OK button to the alert that dismisses the error message only
        i. Display the error message
    
    Uses the following local variables:
        runDistance - A constant double that is the distance selected using the runDistancePicker
        runPace - A constant integer that is the pace selected using the runPacePicker
        runDuration - A constant integer that is the duration selected using the runDurationPicker
        selectedShoe - A constant optional Shoe that is the shoe selected in the runShoePicker
    
    :param: sender The object that called the action (in this case the Save button).
    */
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let runDistance = runDistancePicker.selectedDistance().distance //1
        let runPace = runPacePicker.selectedPace().pace
        let runDuration = runDurationPicker.selectedDuration().duration
        let selectedShoe: Shoe? = runShoePicker.selectedShoe()

        if runDistance > 0 && runPace > 0 && runDuration > 0 { //2
            let run = Run(runID: 0, distance: runDistance, dateTime: runDatePicker!.date, pace: runPace, duration: runDuration, shoe: selectedShoe, runScore: 0, runLocations: nil, splits: nil) //a
            run.calculateRunScore() //b
            Database().saveRun(run) //c
            Database().increaseShoeMiles(selectedShoe, byAmount: runDistance.rawValue) //d
            self.navigationController?.popViewController(animated: true) //e
        } else { //3
            let error = "At least 2 from distance, pace and duration must have been input." //f
            let alert = UIAlertController(title: "Invalid Run", message: error, preferredStyle: .alert) //g
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil)) //h
            self.present(alert, animated: true, completion: nil) //i
        }
    }
}
