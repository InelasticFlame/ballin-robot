//
//  RepeatsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 18/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RepeatsTableViewController: UITableViewController {

    // MARK: - Global Variables

    var repeatOption: String? //A global string variable that stores the selected repeat option (if one has been previously set). This value is set by the NewPlannedRunTableView controller when the segue to this view is called.

    // MARK: - View Life Cycle

    /**
    This method is called by the system whenever the view is about to appear on screen. It calls the function setSelectedRepeatOption (this is used to set up the view if a user has previously set a repeat option).
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        setSelectedRepeatOption()
    }

    // MARK: - Table View Data Source

    /**
    This method is called by the system whenever a user selects a row in the table view. It sets the selection indicator and then dismisses the view to return to the previous view.
    1. Calls the function clearCheckmarks (so that only one row at a time can be chosen as the selected option)
    2. Sets the accessory of the cell selected to a Checkmark
    3. Deselects the cell that was just selected animating the process
    4. IF the current number of view controllers can be counted
        a. IF the previousViewController is a NewPlannedRunTableViewController (the previous view controller will be the one at the index that is 2 less than the count (since counts start from 1 and indexes start at 0))
            i. IF the text of the selected cell can be retrieved
                ii. Call the function setRepeatDetailLabelText on the previous view controller passing the text of the selected cell
    5. Dismiss the current view controller and animate the transition
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearCheckmarks() //1

        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark //2
        tableView.deselectRow(at: indexPath as IndexPath, animated: true) //3

        if let viewControllersCount = self.navigationController?.viewControllers.count { //4

            if let previousVC = self.navigationController?.viewControllers[viewControllersCount - 2] as? NewPlannedRunTableViewController { //a
                if let selectedRepeatOption = tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.text { //i
                    previousVC.setRepeatDetailLabelText(repeatText: selectedRepeatOption) //ii
                }
            }
        }

        navigationController?.popViewController(animated: true) //5
    }

    /**
    This method is used to remove the accessory from all cells. This is so that if a new shoe is selected two checkmarks are not shown on the interface (such that it appears as if 2 rows have been selected)
    1. Declares the local constant sectionCount and sets its value to the number of sections in the table view
    2. FOR each section
        a. Declares the local constant rowCount and sets its value to the number of rows in the current section
        b. FOR each row
            i. Sets the accessory of the cell in the current section for the current row to None
    
    Uses the following local variables:
        sectionCount - An integer constant that is the number of sections in the table view
        sectionNo - An integer variable that is the current section being cleared
        rowCount - An integer constant that is the number of rows in a certain section
        rowNo - An integer variable that is the current row in a section
    */
    func clearCheckmarks() {
        let sectionCount = tableView.numberOfSections

        for sectionNo in 0 ..< sectionCount {

            let rowCount = tableView.numberOfRows(inSection: sectionNo)

            for rowNo in 0 ..< rowCount {
                tableView.cellForRow(at: IndexPath(row: rowNo, section: sectionNo))?.accessoryType = .none
            }
        }
    }

    // MARK: - Navigation

    /**
    This method is called when the view loads. It sets up the view with the last selected repeatOption.
    1. Retrieve the number of rows in the fist section
    2. FOR each cell in the first section
        a. IF the cell can be retrieved
            i. IF the text of the cell's text label is the same as the repeatOption
                ii. Set the accessory of the cell to a Checkmark
    
    Uses the following local variables:
        rowCount - An integer constant that is the number of rows in a certain section
        rowNumber - An integer variable that is the current row
    */
    func setSelectedRepeatOption() {

        let rowCount = tableView.numberOfRows(inSection: 0) //1
        for rowNumber in 0 ..< rowCount { //2
            if let cell = tableView.cellForRow(at: IndexPath(row: rowNumber, section: 0)) { //a
                if cell.textLabel?.text == repeatOption { //i
                    cell.accessoryType = .checkmark //ii
                }
            }
        }
    }
}
