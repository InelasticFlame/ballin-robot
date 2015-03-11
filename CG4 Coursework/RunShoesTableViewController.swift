//
//  RunShoesViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 11/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RunShoesTableViewController: UITableViewController {
    
    var run: Run?
    var selectedShoe: Shoe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(navigationController!.navigationBar.frame.size.height, 0,0,0);
        
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 2
        pageControl.pageIndicatorTintColor = UIColor(red: 122/255, green: 195/255, blue: 252/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 142/255, blue: 185/255, alpha: 1)
        pageControl.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - self.tabBarController!.tabBar.frame.height - 28)
        
        self.view.addSubview(pageControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        if let run = run {
            let finishTimes = run.calculateRunFinishTimes()
            
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))?.detailTextLabel?.text = finishTimes.fiveK
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))?.detailTextLabel?.text = finishTimes.tenK
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))?.detailTextLabel?.text = finishTimes.halfMarathon
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1))?.detailTextLabel?.text = finishTimes.fullMarathon
            
            if let shoe = run.shoe {
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.detailTextLabel?.text = shoe.name
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? RunShoeSelectorTableViewController {
            destinationVC.selectedShoe = selectedShoe
        }
    }
}
