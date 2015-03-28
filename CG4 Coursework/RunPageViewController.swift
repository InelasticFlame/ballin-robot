//
//  RunPageViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 11/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RunPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: - Global Variables
    
    private let pages = ["RunShoeTableViewController", "RunMapViewController", "RunSplitsTableViewController"] //A global constant array of string objects that contain the views to be shown by the PageViewController
    var pagesViewControllers = [UIViewController]() //A global array of UIViewControllers that stores the 3 pages being shown by the PageViewController
    var run: Run? //An optional global variable that stores the run being viewed as a Run object

    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view controller is first loaded. It configures the page controller and the views that it displays.
    1. Sets the delegate and dataSource of the PageViewController to this view controller
    2. Sets the storyboard to use as the storyboard called MainStoryboard
    3. Loads the detailsVC as the view controller with the identifier at stored at index 1 in the pages array; this view controller is of type RunDetailsViewController
    4. Sets the run of the view controller to be this RunPageViewControllers run
    5. Loads the remaining two view controllers in the same way
    6. Stores the 3 view controllers in the array pagesViewControllers in the order they should be in the page control
    7. Sets the initial view controller being shown by the Page View Controller as the detailsVC
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self //1
        self.dataSource = self
        
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil) //2
        
        let detailsVC = storyboard.instantiateViewControllerWithIdentifier(pages[1]) as RunDetailsViewController //3
        detailsVC.run = self.run //4
        let splitsVC = storyboard.instantiateViewControllerWithIdentifier(pages[2]) as RunSplitsTableViewController //5
        splitsVC.run = self.run
        let shoesVC = storyboard.instantiateViewControllerWithIdentifier(pages[0]) as RunShoesTableViewController
        shoesVC.run = self.run
        pagesViewControllers = [shoesVC, detailsVC, splitsVC] //6
        
        self.setViewControllers([detailsVC], direction: .Forward, animated: false, completion: nil) //7
        
    }
    
    //MARK: - Page View Delegate
    
    /**
    This method is called by the system when a user swipes to the left. It returns the next view controller to be shown after this one
    1. IF the current displayed view controller is a RunDetailsViewController
        a. Returns the next view controller as the view controller stored at index 2 in pagesViewControllers (this the RunSplitsTableViewController)
    2. ELSE IF the current displayed view controller is a RunShoesTableViewController
        a. Returns the next view controller as the view controller stored at index 1 in pagesViewControllers (this the RunDetailsViewController)
    3. ELSE returns nil (i.e. no view controller is to be displayed after this view; so a user can swipe left no more)
    
    :param: pageViewController The page view controller requesting the next view controller.
    :param: viewController The view controller that the user navigated away from.
    :returns: The next UIViewController to be displayed by the pageViewController after the current viewController.
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let currentVC = viewController as? RunDetailsViewController { //1
            return pagesViewControllers[2] //1a
        } else if let currentVC = viewController as? RunShoesTableViewController { //2
            return pagesViewControllers[1] //2a
        } else { //3
            return nil
        }
    }
    
    
    /**
    This method is called by the system when a user swipes to the right. It returns the next view controller to be shown after this one
    1. IF the current displayed view controller is a RunDetailsViewController
        a. Returns the next view controller as the view controller stored at index 0 in pagesViewControllers (this the RunShoesTableViewController)
    2. ELSE IF the current displayed view controller is a RunSplitsTableViewController
        a. Returns the next view controller as the view controller stored at index 1 in pagesViewControllers (this the RunDetailsViewController)
    3. ELSE returns nil (i.e. no view controller is to be displayed after this view; so a user can swipe right no more)
    
    :param: pageViewController The page view controller requesting the next view controller.
    :param: viewController The view controller that the user navigated away from.
    :returns: The next UIViewController to be displayed by the pageViewController before the current viewController.
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let currentVC = viewController as? RunDetailsViewController {
            return pagesViewControllers[0]
        } else if let currentVC = viewController as? RunSplitsTableViewController {
            return pagesViewControllers[1]
        } else {
            return nil
        }
    }
}
