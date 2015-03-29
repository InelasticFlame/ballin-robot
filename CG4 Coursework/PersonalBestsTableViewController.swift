//
//  PersonalBestsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 12/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PersonalBestsTableViewController: UITableViewController {
    
    //MARK: - Storyboard Links
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var longestDistanceLabel: UILabel!
    @IBOutlet weak var longestDurationLabel: UILabel!
    @IBOutlet weak var fastestMileLabel: UILabel!
    @IBOutlet weak var bestAveragePaceLabel: UILabel!
    @IBOutlet weak var longestDistanceImageView: UIImageView!
    @IBOutlet weak var longestDurationImageView: UIImageView!
    @IBOutlet weak var fastestMileImageView: UIImageView!
    @IBOutlet weak var bestAveragePaceImageview: UIImageView!
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system whenever the view appears on screen. It is used to configure the interface with the personal bests of a user.
    1. Initialises and stores a reference to the standardUserDefaults
    2. Declares the local constant UIImage achievedImage which is the image called "trophyImage90px"
    3. Retrieves the longestDistance, longestDuration, fastestMile and fastestAveragePace from the userDefaults
    4. IF there is a longestDistance
        a. Set the text of the longestDistanceLabel to the longestDistance converted to a string using the Conversions class
        b. Set the image of the longestDistanceImageView to the achieved image
    5. This process is the repeated for the other 3 personal bests
    
    Uses the following local variables:
        userDefaults - A constant reference to the standard user defaults
        achievedImage - A constant UIImage that is the image to display if a personal best has been achieved
        longestDistance - A constant double that is the longest distance from the user defaults
        longestDuration - A constant integer that is the longest duration from the user defaults
        fastestMile - A constant integer that is the fastest mile from the user defaults
        fastestAveragePace - A constant integer that is the fastest pace from the user defaults
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults() //1
        let achievedImage = UIImage(named: "trophyImage90px") //2
        let longestDistance = userDefaults.doubleForKey(Constants.DefaultsKeys.PersonalBests.LongestDistanceKey) //3
        let longestDuration = userDefaults.integerForKey(Constants.DefaultsKeys.PersonalBests.LongestDurationKey)
        let fastestMile = userDefaults.integerForKey(Constants.DefaultsKeys.PersonalBests.FastestMileKey)
        let fastestAveragePace = userDefaults.integerForKey(Constants.DefaultsKeys.PersonalBests.FastestAvgPaceKey)
        
        if longestDistance > 0 { //4
            longestDistanceLabel.text = Conversions().distanceForInterface(longestDistance) //a
            longestDistanceImageView.image = achievedImage //b
        }
        
        //5
        
        if longestDuration > 0 {
            longestDurationLabel.text = Conversions().runDurationForInterface(longestDuration)
            longestDurationImageView.image = achievedImage
        }
            
        if fastestMile > 0 {
            fastestMileLabel.text = Conversions().averagePaceForInterface(fastestMile)
            fastestMileImageView.image = achievedImage
        }
        
        if fastestAveragePace > 0 {
            bestAveragePaceLabel.text = Conversions().averagePaceForInterface(fastestAveragePace)
            bestAveragePaceImageview.image = achievedImage
        }
    }
}
