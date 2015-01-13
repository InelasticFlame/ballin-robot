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
    var optionalRun: Run?
    @IBOutlet var mapKitView: UIView!
    @IBOutlet var overlayView: MapOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let run = optionalRun {
            overlayView.distanceLabel.text = Conversions().distanceForInterface(run.distance)
            overlayView.scoreLabel.text = NSString(format: "%1.1lf points", run.score)
            overlayView.timeLabel.text = Conversions().timeForInterface(run.dateTime)
            overlayView.dateLabel.text = Conversions().dateToString(run.dateTime)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let run = optionalRun { //add the progress bar
            let progressBackground = UIView(frame: overlayView.headerOverlay.frame)
            progressBackground.backgroundColor = Conversions().returnScoreColour(run)
            progressBackground.alpha = 0.4
            progressBackground.frame.size.width = progressBackground.frame.size.width * CGFloat(run.score / 1000)
            overlayView.headerOverlay.addSubview(progressBackground)
            overlayView.headerOverlay.bringSubviewToFront(overlayView.dateLabel)
            overlayView.headerOverlay.bringSubviewToFront(overlayView.timeLabel)
        }
        
        Conversions().addBorderToView(mapKitView)
        Conversions().addBorderToView(overlayView.headerOverlay)
    }
    
    func drawRouteLineOnMap() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
