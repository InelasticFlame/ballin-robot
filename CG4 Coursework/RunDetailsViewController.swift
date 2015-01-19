//
//  RunDetailsViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 30/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit
import MapKit

class RunDetailsViewController: UIViewController {
    var run: Run?
    @IBOutlet var mapKitView: UIView!
    @IBOutlet var overlayView: MapOverlay!
    
    /**
    1. IF there is a run
        a. Convert the run distance to a string and set the distanceLabel text as the string
        b. Convert the run score to a string and set the scoreLabel text as the string
        c. Convert the run time to a string and set the timeLabel text as the string
        d. Convert the run date to a string and set the dateLabel text as the string
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        if let run = run { //1
            overlayView.distanceLabel.text = Conversions().distanceForInterface(run.distance) //a
            overlayView.scoreLabel.text = NSString(format: "%1.1lf points", run.score) //b
            overlayView.timeLabel.text = Conversions().timeForInterface(run.dateTime) //c
            overlayView.dateLabel.text = Conversions().dateToString(run.dateTime) //d
        }
    }
    
    /**
    1. IF there is a run
        a. Create a UIView that is the same size as the headerOverlay from the overlayView
        b. Retrieve the correct colour for the run score at set that as the background of the view
        c. Make the background slightly transparent
        d. Set the width of the view to it's current width times the decimal of the run score
        e. Add the view as a subview of the headerOverlay
        f. Re-order the views so the date and time labels are at the front of the background
    2. Add a border to the mapKitView
    3. Add a border to the headerOverlay
    */
    override func viewDidAppear(animated: Bool) {
        if let run = run { //1
            let progressBackground = UIView(frame: overlayView.headerOverlay.frame) //a
            progressBackground.backgroundColor = Conversions().returnScoreColour(run) //b
            progressBackground.alpha = 0.4 //c
            progressBackground.frame.size.width = progressBackground.frame.size.width * CGFloat(run.score / 1000) //d
            overlayView.headerOverlay.addSubview(progressBackground) //e
            overlayView.headerOverlay.bringSubviewToFront(overlayView.dateLabel) //f
            overlayView.headerOverlay.bringSubviewToFront(overlayView.timeLabel) //g
        }
        
        Conversions().addBorderToView(mapKitView) //2
        Conversions().addBorderToView(overlayView.headerOverlay) //3
    }
    
    func drawRouteLineOnMap() {
        if let run = run {
            if let locations = run.locations {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
