//
//  MyShoesTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 05/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class MyShoesTableViewController: UITableViewController {
    
    //MARK: - Global Variables
    
    private var shoes = [Shoe]() //A global array of shoe objects that stores the shoes being displayed in the table view
    
    //MARK: - View Life Cycle

    /**
    This method is called by the system whenever the view is about to appear on screen.
    1. Sets the right bar button item to an edit button
    2. Loads all the shoes from the database as an array of Shoe objects, storing them in the array shoes
    3. Reloads the data in the table view
    */
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem() //1
        shoes = Database().loadAllShoes() as [Shoe] //2
        
        tableView.reloadData() //3
    }
    
    // MARK: - Table View Data Source

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of sections in the table, which in this case is fixed as 1.
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /**
    This method is called by the system whenever the tableView loads its data. It returns the number of rows in a section, which is the number of shoes in the array of shoes + 1 (for the Add Shoe option)
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoes.count + 1
    }

    /**
    This method is called by the system when the data is loaded in the table, it creates a new cell and populates it with the data for a particular shoe.
    1. IF there are no shoes OR the current row is the last row (the number of shoes in the array)
        a. Create a new addNewShoeCell
        b. Return the cell
    2. ELSE
        c. Create a new shoeCell
        d. Retrieve the shoe for this cell as the shoe at the indexPath row
        e. Set the shoeNameLabel text to the name of the shoe
        f. Set the shoeMilesLabel text as the shoe miles converted to a string using the Conversions class
        g. Load the shoe image
        h. IF there is a shoe image
            i. Set the shoeImageView image to the shoe image
        j. Return the cell
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if shoes.count == 0 || indexPath.row == shoes.count { //1
            let cell = tableView.dequeueReusableCellWithIdentifier("addNewShoeCell", forIndexPath: indexPath) as UITableViewCell //a
            
            return cell //b
        } else { //2
            let cell = tableView.dequeueReusableCellWithIdentifier("shoeCell", forIndexPath: indexPath) as ShoeTableViewCell //c
            
            let shoe = shoes[indexPath.row] //d
            
            cell.shoeNameLabel.text = shoe.name //e
            cell.shoeMilesLabel.text = Conversions().distanceForInterface(shoe.miles) //f
            
            let shoeImage = shoe.loadImage() //g
            
            if shoeImage != nil { //h
                cell.shoeImageView.image = shoeImage //i
            }
            
            return cell //j
        }
    }
    
    /**
    This method is called by the system when a user presses the edit button. It checks to see if a cell can be edited.
    1. IF the cell is an addNewShoeCell
        a. Return false
    2. ELSE return true
    */
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "addNewShoeCell" { //1
            return false //a
        } else { //2
            return true
        }
    }
    
    /**
    This method is called by the system whenever the data is loaded in the table view. It returns the height for a particular cell, which in this case is 90 for all cells.
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    /**
    This method is called by the system when a user selects a row in the table view. It deselects the cell and animates the process.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
    }

    /**
    This method is called when a user presses the delete button whilst the table is in edit mode.
    1. IF the edit being performed is a delete
        a. Calls the function deleteShoe from the Database class, IF it is successful
            i. Remove the shoe from the array of shoe
           ii. Delete the row from the table view
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { //1
            if Database().deleteShoe(shoes[indexPath.row]) { //a
                shoes.removeAtIndex(indexPath.row) //i
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) //ii
            }
        }
    }
}
