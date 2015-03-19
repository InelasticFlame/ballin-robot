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
    
    private var shoes = [Shoe]()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        shoes = Database().loadAllShoes() as [Shoe]
        
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shoes.count > 0 {
            return shoes.count + 1
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if shoes.count == 0 || indexPath.row == shoes.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("addNewShoeCell", forIndexPath: indexPath) as UITableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("shoeCell", forIndexPath: indexPath) as ShoeTableViewCell
            
            let shoe = shoes[indexPath.row]
            
            cell.shoeNameLabel.text = shoe.name
            cell.shoeMilesLabel.text = Conversions().distanceForInterface(shoe.miles)
            
            let shoeImage = shoe.loadImage()
            
            if shoeImage != nil {
                println("Shoe has image")
                cell.shoeImageView.image = shoeImage
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "addNewShoeCell" {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
