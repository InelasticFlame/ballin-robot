//
//  RunPageViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 11/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RunPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pages = ["RunShoeTableViewController", "RunMapViewController", "RunSplitsTableViewController"]
    var pagesViewControllers = [UIViewController]()
    var run: Run? //An optional variable to store a Run object

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        
        let detailsVC = storyboard.instantiateViewControllerWithIdentifier(pages[1]) as RunDetailsViewController
        detailsVC.run = self.run
        let splitsVC = storyboard.instantiateViewControllerWithIdentifier(pages[2]) as RunSplitsTableViewController
        splitsVC.run = self.run
        let shoesVC = storyboard.instantiateViewControllerWithIdentifier(pages[0]) as RunShoesTableViewController
        shoesVC.run = self.run
        pagesViewControllers = [shoesVC, detailsVC, splitsVC]
        
        self.setViewControllers([detailsVC], direction: .Forward, animated: false, completion: nil)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let currentVC = viewController as? RunDetailsViewController {
            return pagesViewControllers[2]
        } else if let currentVC = viewController as? RunShoesTableViewController {
            return pagesViewControllers[1]
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let currentVC = viewController as? RunDetailsViewController {
            return pagesViewControllers[0]
        } else if let currentVC = viewController as? RunSplitsTableViewController {
            return pagesViewControllers[1]
        } else {
            return nil
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
