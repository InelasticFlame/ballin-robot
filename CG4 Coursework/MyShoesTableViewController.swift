//
//  MyShoesTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 05/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class MyShoesTableViewController: UITableViewController {

    private var shoes = [Shoe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
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
            let cell = tableView.dequeueReusableCellWithIdentifier("shoeCell", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel?.text = shoes[indexPath.row].name
            cell.detailTextLabel?.text = Conversions().distanceForInterface(shoes[indexPath.row].miles)
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let imagePath = paths.stringByAppendingPathComponent("\(shoes[indexPath.row].imageName).png")
            
            let shoeImage = UIImage(contentsOfFile: imagePath)
            if shoeImage != nil {
                println("Shoe has image")
                cell.imageView?.image = shoeImage
            }
            
            return cell
        }
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
