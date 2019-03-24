//
//  RunShoeSelectorTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 11/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RunShoeSelectorTableViewController: UITableViewController {

    private var shoes = [Shoe]() //A private, global array of Shoe objects that stores the shoes available to select and is used to populate the table view
    var run: Run? //A global optional variable to store the run being displayed as a Run object
    
    /**
    This method is called by the system whenever the view is about to appear. It configures the view to its initially state ready to display on the screen.
    1. Sets the global array shoes as the array return from the loadAllShoes method from the Database class, stating that the returned object is an array of Shoe objects
    2. Reloads the data in the table view
    3. IF the run has a shoe
        a. Loops through each shoe in the array
        b. IF the selectedShoe's ID matches the current shoe in the array
            i. Sets the accessory of the cell at the indexPath with a row 1 greater than the current shoe index to a checkmark (the row is 1 greater than that of the shoe index as the first row is used for the "None" option)
    4. ELSE sets the accessory of the first cell in the table to a checkmark
    
    Uses the following local variables:
        shoeNo - An integer variable that is the current shoe number in the array shoes
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        shoes = Database().loadAllShoes() as! [Shoe] //1
        
        tableView.reloadData() //2
        
        if let selectedShoe = run?.shoe { //3
            
            for shoeNo in 0 ..< shoes.count { //a
                if selectedShoe.ID == shoes[shoeNo].ID { //b
                    tableView.cellForRow(at:IndexPath(row: shoeNo + 1, section: 0))?.accessoryType = .checkmark //i
                }
            }
        } else { //4
            tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath)?.accessoryType = .checkmark
        }
    }

    // MARK: - Table View Data Source

    /**
    This method is called by the system whenever the table view data is loaded. It returns the number of sections in the table view which in this case is fixed as 1.
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :returns: An integer value that is the number of sections in the table view.
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    /**
    This method is called by the system whenever the table view data is loaded. It returns the number of rows in the table view. In this case it returns 1 more than the total number of shoes (this is because there is one row to be used for a "None" option)
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: section The section that's number of rows needs returning as an integer.
    :returns: An integer value that is the number of rows in the section.
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoes.count + 1
    }

    /**
    This method is called by the system whenever the table view data is loaded. It creates a new cell and populates it with the appropriate data.
    1. Creates the new cell as a table view cell with the identifier "shoeCell"
    2. IF the current row is the first
        a. Sets the text label of the cell to "None"
    3. ELSE
        a. Sets the text label to the shoe name at then index 1 less than the current row (1 less because the first row is a 'None' cell so the table view is one step ahead of the array)
    4. Returns the cell
    
    Uses the following local variables:
        cell - A UITableView cell for the current indexPath
    
    :param: tableView The UITableView that is requesting the cell.
    :param: indexPath The NSIndexPath of the cell requested.
    :returns: The UITableViewCell for the indexPath.
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoeCell", for: indexPath as IndexPath) as UITableViewCell //1
        
        if indexPath.row == 0 { //2
            cell.textLabel?.text = "None" //2a
        } else { //3
            cell.textLabel?.text = shoes[indexPath.row - 1].name //3a
        }
        
        return cell //4
    }

    /**
    This method is called by the system whenever a user selects a row in the table view. It removes any existing selection, updates the view for the new selection and updates the mileage of each shoe in the database.
    1. Calls the local function clearCheckmarks
    2. Sets the accessory of the cell at the selected indexPath to a Checkmark
    3. Deselects the selected row with an animation
    4. IF viewControllerCount initialises with the number of view controllers controlled by the navigation controller is not nil
        a. IF the viewController at index viewControllerCount - 2 (The last view displayed will be the one before the currently displayed one, since the first number is a count it is one greater than the maximum index hence we take away 2) is a RunPageViewController
        b. Declares and initialises the local constant shoesVC which is the first viewController stored in the pagesViewControllers variable on the last view controller; IF it is a RunShoesTableViewController
            i. Declares the optional local variable selectedShoe of type Shoe
           ii. IF the current row is 0, set the selected shoe as 0
          iii. ELSE set the selected shoe as the shoe in shoes at the index one less than the current row (since the indexPaths are 1 ahead of the array)
           iv. Calls the function saveShoe from the Database class passing the selected shoe and the run, IF it is successful
                v. IF there is a run
                   vi. IF the selectedShoe has a different ID to the current run shoe
                     viii. IF there is a selectedShoe, call the function inceaseShoeMiles from the Database class passing the selectedShoe and the run distance
                       ix. IF there is an run shoe, call the function decreaseShoeMiles from the Database class passing the oldShoe and the run distance
                x. Sets the shoe of the run stored on the shoesVC to the selectedShoe
               xi. Removes the current view controller from the view hierarchy
    
    Uses the following local variables:
        selectedShoe - An option Shoe variable that is the show selected on the interface
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearCheckmarks() //1
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark //2
        tableView.deselectRow(at: indexPath as IndexPath, animated: true) //3
        
        
        if let viewControllerCount = self.navigationController?.viewControllers.count { //4
            
            if let previousVC = self.navigationController?.viewControllers[viewControllerCount - 2] as? RunPageViewController { //a
                if let shoesVC = previousVC.pagesViewControllers[0] as? RunShoesTableViewController { //b
                    var selectedShoe: Shoe? //i
                    
                    if indexPath.row == 0 { //ii
                        selectedShoe = nil
                    } else { //iii
                        selectedShoe = shoes[indexPath.row - 1]
                    }
                    
                    if Database().saveShoe(selectedShoe, toRun: run) { //iv
                        if let run = run { //v
                            if selectedShoe?.ID != run.shoe?.ID { //vi
                                if let selectedShoe = selectedShoe { //viii
                                    Database().increaseShoeMiles(selectedShoe, byAmount: run.distance)
                                    selectedShoe.miles += run.distance
                                }
                                if let oldShoe = run.shoe { //ix
                                    Database().decreaseShoeMiles(oldShoe, byAmount: run.distance)
                                    oldShoe.miles -= run.distance
                                }
                            }
                        }

                        shoesVC.run?.shoe = selectedShoe //x
                        navigationController?.popViewController(animated: true) //xi
                    }
                }
            }
        }
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
}
