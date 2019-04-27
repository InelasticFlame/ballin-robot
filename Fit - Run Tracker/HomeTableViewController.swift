//
//  HomeTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit
import HealthKit

class HomeTableViewController: UITableViewController {

    // MARK: - Storyboard Links

    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var distanceHeaderView: UIView!
    @IBOutlet weak var distanceMainView: UIView!
    @IBOutlet weak var shoesHeaderView: UIView!
    @IBOutlet weak var shoesMainView: UIView!
    @IBOutlet weak var personalBestsHeaderView: UIView!
    @IBOutlet weak var personalBestMainView: UIView!
    @IBOutlet weak var distanceProgressView: UIView!

    @IBOutlet weak var distanceProgressLabel: UILabel!
    @IBOutlet weak var shoeNameLabel: UILabel!
    @IBOutlet weak var shoeDistanceLabel: UILabel!
    @IBOutlet weak var shoeImageView: UIImageView!
    @IBOutlet weak var longestDurationLabel: UILabel!
    @IBOutlet weak var bestAveragePaceLabel: UILabel!
    @IBOutlet weak var longestDistanceLabel: UILabel!
    @IBOutlet weak var fastestMileLabel: UILabel!

    private var shoes = [Shoe]() //A global array of Shoe objects that stores the shoes in the database.

    // MARK: - View Life Cycle

    /**
    This method is called by the system when the view is first loaded. It adds borders to the views on screen.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceHeaderView.addBorder(borderWidth: 2)
        distanceMainView.addBorder(borderWidth: 2)
        shoesHeaderView.addBorder(borderWidth: 2)
        shoesMainView.addBorder(borderWidth: 2)
        personalBestsHeaderView.addBorder(borderWidth: 2)
        personalBestMainView.addBorder(borderWidth: 2)
    }

    /** 
    This method is called by the system whenever the view will appear.
    1. IF initial setup has not been complete
        a. Retrieve the main storyboard
        b. Retrieve the setup view controller
        c. Present the setup view controller
    2. Calls the function loadPersonalBests
    3. Call the function loadDistanceProgress
    4. Call the function loadShoes, passing an NSTimer with the userInfo of a dictionary containing 0
        (a timer is initially created and passed because the function is called using a timer so it will cycle round in a timer)
    
    Uses the following local variables:
        storyboard - A constant UIStoryboard that is the main story board
        newVC - A constant UIViewController that is the setup view controller
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewDidAppear(_ animated: Bool) {

        if !UserDefaults.standard.bool(forKey: Constants.DefaultsKeys.InitialSetup.SetupKey) { //1
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil) //a
            let setupVC = storyboard.instantiateViewController(withIdentifier: "setupStoryboard") as UIViewController //b
            self.present(setupVC, animated: true, completion: nil) //c
        }

        loadPersonalBests() //2
        loadDistanceProgress() //3
        loadShoes(timer: Timer(timeInterval: 0, target: self, selector: #selector(HomeTableViewController.loadShoes), userInfo: NSDictionary(object: NSNumber(value: 0), forKey: "currentShoe" as NSCopying), repeats: false)) //4
    }

    /**
    This method is called by the system whenever the data is loaded in the table. It returns the height for a cell in the table which in this case is always 320
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: indexPath The NSIndexPath of the row that's height is being requested.
    :returns: A CGFloat value that is the rows height.
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }

    /**
    This method is called to loads the shoes to the interface.
    1. Loads all the shoes from the database as an array of Shoe objects
    2. IF there are shoes
        a. Retrieve the userInfo from the timer
        b. Retrieve the current shoe as the object in the dictionary with the key "currentShoe" and its integer value
        c. IF the currentShoe is the same as the number of shoes, reset the value of currentShoe to 0
        d. Set the text of the shoeName label to the name of the current shoe
        e. Set the text of the shoeDistance label to the current miles of the shoe, conveted to a string using the Conversions class
        f. Load the shoe image
        g. IF there is an image
            i. Set the shoeImageView image to the shoeImage
        h. ELSE
           ii. Set the image to the default image (ShoeTab30)
        i. Create a new timer for 3 seconds that will call "loadShoes" when it finishes. Storing the userInfo of a dictionary with the currentShoe increased by one in it
    3. ELSE
        j. Set the text of the shoeNameLabel to "No Shoes"
    
    Uses the following local variables:
        userInfo - A constant NSDictionary that is the user info from the timer
        currentShoe - An integer variable that is the index of the current shoe being displayed
        shoeImage - A constant UIImage that is the shoe's image
    
    :param: timer The NSTimer object that calls the function.
    */
    func loadShoes(timer: Timer) {
        shoes = Database().loadAllShoes() as! [Shoe] //1
        if shoes.count > 0 { //2
            let userInfo = timer.userInfo as! NSDictionary //a
            var currentShoe = (userInfo.object(forKey: "currentShoe") as AnyObject).integerValue //b
            if currentShoe == shoes.count { //c
                currentShoe = 0
            }

            shoeNameLabel.text = shoes[currentShoe!].name //d
            shoeDistanceLabel.text = Conversions().distanceForInterface(distance: shoes[currentShoe!].miles) //e
            let shoeImage = shoes[currentShoe!].loadImage() //f
            if shoeImage != nil { //g
                shoeImageView.image = shoeImage //i
            } else { //h
                shoeImageView.image = UIImage(named: "ShoeTab30") //ii
            }
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(HomeTableViewController.loadShoes), userInfo: NSDictionary(object: NSNumber(value: currentShoe! + 1), forKey: "currentShoe" as NSCopying), repeats: false)
        } else { //3
            shoeNameLabel.text = "No Shoes" //j
        }
    }

    /**
    This method is called to load the distance progress to the interface.
    1. Clear any existing progress bars
    2. Retrieve the goal miles from the NSUserDefaults
    3. Retrieve the current month as a string
    4. Load all the runs for this month from the Database as an array of Run objects
    5. Calculate the total miles
    6. Calculate the progress towards to the goal distance
    7. Create the frame for the progress bar (the same frame as the progress view but at the origin)
    8. Create the progress bar
    9. Add the progress bar as a subview of the distanceProgressBar view
   10. Set the text of the distance progress label
    
    Uses the following local variables:
        view - The current UIView in the distanceProgressView subviews
        goalMiles - A constant double that is the goal distance from the user defaults
        currentMonth - A constant string that is the current month
        runs - A constant array of run objects loaded from the database
        totalMiles - A constant double that is the total distance ran this month
        progress - A constant double that is the amount of progress made towards the goal distance
        progressFrame - A constant CGRect which is the frame to use for the progress bar    
        progressBar - A constant ProgressBar
    */
    func loadDistanceProgress() {
        for view in distanceProgressView.subviews as [UIView] { //1
            view.removeFromSuperview()
        }

        let goalMiles = UserDefaults.standard.double(forKey: Constants.DefaultsKeys.Distance.GoalKey) //2
        let currentMonth = NSDate().monthYearString() //3
        let runs = Database().loadRuns(withQuery: "WHERE RunDateTime LIKE '___\(currentMonth)%'") as! [Run] //4
        let totalMiles = Conversions().totalUpRunMiles(runs: runs) //5
        let progress = CGFloat(totalMiles/goalMiles) //6

        let progressFrame = CGRect(x: 0, y: 0, width: distanceProgressView.frame.width, height: distanceProgressView.frame.height) //7
        let progressBar = ProgressBar(progress: progress, frame: progressFrame) //8
        self.distanceProgressView.addSubview(progressBar) //9

        distanceProgressLabel.text = Conversions().distanceForInterface(distance: totalMiles) + " of " + Conversions().distanceForInterface(distance: goalMiles) + " ran this month." //10
    }

    /**
    This method is called to fill the personal bests cell with the personal bests.
    1. Initialises and stores a reference to the standardUserDefaults
    2. Retrieves the longestDistance, longestDuration, fastestMile and fastestAveragePace from the userDefaults
    3. IF there is a longestDistance
        a. Set the text of the longestDistanceLabel to the longestDistance converted to a string using the Conversions class
    4. This process is the repeated for the other 3 personal bests
    
    Uses the following local variables:
        userDefaults - A constant reference to the standard user defaults
        longestDistance - A constant double that is the longest distance from the user defaults
        longestDuration - A constant integer that is the longest duration from the user defaults
        fastestMile - A constant integer that is the fastest mile from the user defaults
        fastestAveragePace - A constant integer that is the fastest pace from the user defaults
    */
    func loadPersonalBests() {
        let userDefaults = UserDefaults.standard //1
        let longestDistance = userDefaults.double(forKey: Constants.DefaultsKeys.PersonalBests.LongestDistanceKey) //2
        let longestDuration = userDefaults.integer(forKey: Constants.DefaultsKeys.PersonalBests.LongestDurationKey)
        let fastestMile = userDefaults.integer(forKey: Constants.DefaultsKeys.PersonalBests.FastestMileKey)
        let fastestAveragePace = userDefaults.integer(forKey: Constants.DefaultsKeys.PersonalBests.BestAvgPaceKey)

        if longestDistance > 0 { //4
            longestDistanceLabel.text = "Longest Distance: " + Conversions().distanceForInterface(distance: longestDistance) //a
        }

        //4

        if longestDuration > 0 {
            longestDurationLabel.text = "Longest Duration: " + Conversions().runDurationForInterface(duration: longestDuration)
        }

        if fastestMile > 0 {
            fastestMileLabel.text = "Fastest Mile: " + Conversions().averagePaceForInterface(pace: fastestMile)
        }

        if fastestAveragePace > 0 {
            bestAveragePaceLabel.text = "Best Avg. Pace: " + Conversions().averagePaceForInterface(pace: fastestAveragePace)
        }
    }
}
