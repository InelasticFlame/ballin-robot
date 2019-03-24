//
//  RunSplitsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 11/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RunSplitsTableViewController: UITableViewController {

    //MARK: - Global Variables
    
    var run: Run? //A global optional variable to store the run being displayed as a Run object
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is first loaded. It configures the view ready for display.
    1. Adds padding to the top of the table view so that it doesn't display under the navigation bar
    2. Declares and initialises the local constant pageControl as a UIPageControl
    3. Sets the number of pages to 3
    4. Sets the current page to 2 (that is the third page)
    5. Sets the page indicator tint colour (the colour of the circles of the not currently shown page)
    6. Sets the current page indicator tint colour (the colour of the circle of the currently shown page)
    7. Sets the position of the page control to the middle of the screen in the x direction and just at the bottom of the table view (-28 pixels for padding)
    8. Adds the page control as a subview of the current view
    
    Uses the following local variables:
        pageControl - A UIPageControl to add to the interface
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsets.init(top: navigationController!.navigationBar.frame.size.height, left: 0,bottom: 0,right: 0); //1
        
        let pageControl = UIPageControl() //2
        pageControl.numberOfPages = 3 //3
        pageControl.currentPage = 2 //4
        pageControl.pageIndicatorTintColor = UIColor(red: 122/255, green: 195/255, blue: 252/255, alpha: 1) //5
        pageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 142/255, blue: 185/255, alpha: 1) //6
        pageControl.center = CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height - self.tabBarController!.tabBar.frame.height - 28)
        
        self.view.addSubview(pageControl) //8
    }

    /**
    This method is called by the system when the view appears on screen. If there are no splits for a particular run it hides the table view and adds a label explaining the problem.
    1. IF there are no splits
        a. Creates a new label that is the size of the screen
        b. Sets the text of the label
        c. Sets the text colour to dark gray
        d. Sets the number of lines to 0; this tells the label to use as many lines as needed to fit all the text on
        e. Sets the text to align center
        f. Sets the font to the system font of size 16
        g. Sizes the label to fix the view
        h. Sets the background of the table view to the created label
    
    Uses the following local variables:
        noSplitsLabel - A UILabel to display if there are no splits
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewDidAppear(_ animated: Bool) {
        if run?.splits.count == 0 {
            let noSplitsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)) //a
            noSplitsLabel.text = "There are no splits stored for this run." //b
            noSplitsLabel.textColor = UIColor.black //c
            noSplitsLabel.numberOfLines = 0 //d
            noSplitsLabel.textAlignment = .center //e
            noSplitsLabel.font = UIFont(name: "System", size: 16) //f
            noSplitsLabel.sizeToFit() //g
            
            self.tableView.backgroundView = noSplitsLabel //h
        }
    }
    
    // MARK: - Table View Data Source

    /**
    This method is called by the system whenever the table view data is loaded. It returns the number of sections in the table view which in this case is fixed as 1
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :returns: An integer value that is the number of sections in the table view.
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
    This method is called by the system whenever the table view data is loaded. It returns the number of rows in the table view. In this case, if there is a run it returns the number of splits stored otherwise it returns 0
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: section The section that's number of rows needs returning as an integer.
    :returns: An integer value that is the number of rows in the section.
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let run = run {
            return run.splits.count
        } else {
            return 0
        }
    }

    
    /**
    This method is called by the system when the data is loaded in the table, it creates a new cell and populates it with the data for a particular split.
    1. Creates the cell as a cell with the identifier "splitsCell"
    2. Sets the text label of the cell to the "Mile: " + indexPath's row
    3. Sets the detail text label of the cell text to run split at the current row converted to a string using the Conversions class
        (NOTE: run is unwrapped as if any cells are being loaded in the table there MUST be a run as there has to be a splits in the first place)
    4. Returns the cell
    
    Uses the following local variables:
        cell - A UITableView cell for the current indexPath
    
    :param: tableView The UITableView that is requesting the cell.
    :param: indexPath The NSIndexPath of the cell requested.
    :returns: The UITableViewCell for the indexPath.
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "splitsCell", for: indexPath as IndexPath) as UITableViewCell //1

        cell.textLabel?.text = "Mile: \(indexPath.row + 1)" //2
        cell.detailTextLabel?.text = Conversions().averagePaceForInterface(pace: run!.splits[indexPath.row]) //3

        return cell //4
    }

}
