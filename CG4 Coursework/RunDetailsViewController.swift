//
//  RunDetailsViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 30/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit
import MapKit

class RunDetailsViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Storyboard Links
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var overlayView: MapOverlay!
    @IBOutlet weak var finishTimesLabel: UILabel!
    @IBOutlet weak var avgPaceView: UIView!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    
    //MARK: - Global Variables
    
    var run: Run?
    var finishTimes: (String, String, String, String)?
    var currentFinishTime = "5k"
    
    //MARK: - View Life Cycle
    
    /**
    1. Sets the delegate of the mapKitView to this view controller
    2. IF the run has locations
        a. Calls the function drawRouteLineOnMap
    3. ELSE
        b. Calls the function hideMapForNoLocations
    4. IF there is a run
        c. Convert the run distance to a string and set the distanceLabel text as the string
        d. Convert the run score to a string and set the scoreLabel text as the string
        e. Convert the run time to a string and set the timeLabel text as the string
        f. Gets the run date's short date string and set it as the dateLabel text
    
        g. Retrieves the finish times for other distances
        h. Calls the function updateFinishTimesLabel
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self //1
        
        if run?.locations.count > 0 { //2
            drawRouteLineOnMap() //a
        } else { //3
            hideMapForNoLocations() //b
        }
        
        if let run = run { //4
            overlayView.distanceLabel.text = Conversions().distanceForInterface(run.distance) //c
            overlayView.scoreLabel.text = NSString(format: "%1.1lf pnts", run.score) //d
            overlayView.timeLabel.text = Conversions().timeForInterface(run.dateTime) //e
            overlayView.dateLabel.text = run.dateTime.shortDateString() //f
            
            finishTimes = run.calculateRunFinishTimes() //g
            updateFinishTimesLabel() //h
        }
    }
    
    /**
    1. IF there is a run
        a. Create a UIView that is the same size as the headerOverlay from the overlayView
        b. Retrieve the correct colour for the run score at set that as the background of the view
        c. Make the background slightly transparent
        d. Set the width of the view to it's current width times the decimal of the run score
        e. Add the view as a subview of the headerOverlay
       fg. Re-order the views so the date and time labels are at the front of the background
    2. Add a border to the mapKitView
    3. Add a border to the headerOverlay
    */
    override func viewDidAppear(animated: Bool) {
        if let run = run { //1
            let progressBackground = UIView(frame: overlayView.headerOverlay.frame) //a
            progressBackground.backgroundColor = run.scoreColour() //b
            progressBackground.alpha = 0.4 //c
            progressBackground.frame.size.width = progressBackground.frame.size.width * CGFloat(run.score / 1000) //d
            overlayView.headerOverlay.addSubview(progressBackground) //e
            overlayView.headerOverlay.bringSubviewToFront(overlayView.dateLabel) //f
            overlayView.headerOverlay.bringSubviewToFront(overlayView.timeLabel) //g
            
            avgPaceLabel.text = Conversions().averagePaceForInterface(run.pace)
            durationLabel.text = "Time: " + Conversions().runDurationForInterface(run.duration)
            durationView.addBorder(2)
            avgPaceView.addBorder(2)
        }
        
        mapKitView.addBorder(2) //2
        overlayView.headerOverlay.addBorder(2) //3
    }
    
    /**
    1. Creates and starts a timer that calls the function 'updateFinishTimesLabel' after 4 seconds
    2. IF there are finishTimes
        a. IF the currentFinishTime is 5k
            i. Set the text of finishTimesLabel to the first stored finishTime
           ii. Change the currentFinishTime to '10k'
        b. ELSE IF the currentFinishTime is 10k
            i. Set the text of finishTimesLabel to the second stored finishTime
           ii. Change the currentFinishTime to 'Half'
        c. ELSE IF the currentFinishTime is Half
            i. Set the text of finishTimesLabel to the third stored finishTime
           ii. Change the currentFinishTime to 'Full'
        d. ELSE IF the currentFinishTime is Full
            i. Set the text of finishTimesLabel to the fourth stored finishTime
           ii. Change the currentFinishTime to '5k'
    */
    func updateFinishTimesLabel() {
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "updateFinishTimesLabel", userInfo: nil, repeats: false) //1
        
        if let finishTimes = finishTimes { //2
            if currentFinishTime == "5k" { //a
                finishTimesLabel.text = finishTimes.0 //i
                currentFinishTime = "10k" //ii
            } else if currentFinishTime == "10k" { //b
                finishTimesLabel.text = finishTimes.1 //i
                currentFinishTime = "Half" //ii
            } else if currentFinishTime == "Half" { //c
                finishTimesLabel.text = finishTimes.2 //i
                currentFinishTime = "Full" //ii
            } else if currentFinishTime == "Full" { //d
                finishTimesLabel.text = finishTimes.3 //i
                currentFinishTime = "5k" //ii
            }
        }
        
    }
    
    //MARK: - Map Drawing Methods
    
    
    /**
    This method is used to drawn the run route onto the map.
    1. IF the user preference is for a Satellite map, set the map to Satellite
    2. IF the user preference is for a Hybrid map, set the map to Hybrid
    3. ELSE set the map to standard
    4. IF there is a run
        a. Create an array of CLLocationCoordinate2D
        b. FOR each location, and the locations coordinates to the array
        c. Create the polyline for the array of coordinates
        d. Add the polyline to the map as an overlay
        e. Call the function centreMapOnRunArea
    */
    func drawRouteLineOnMap() {
        if NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.MapStyle.StyleKey) == Constants.DefaultsKeys.MapStyle.Satellite { //1
            mapKitView.mapType = .Satellite
        } else if NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.MapStyle.StyleKey) == Constants.DefaultsKeys.MapStyle.Hybrid { //2
            mapKitView.mapType = .Hybrid
        } else { //3
            mapKitView.mapType = .Standard
        }
        
        if let run = run { //4
            var coords = Array<CLLocationCoordinate2D>() //a
            for location in run.locations { //b
                coords.append(location.coordinate)
            }
            let polyLine = MKPolyline(coordinates: &coords, count: coords.count) //c
            mapKitView.addOverlay(polyLine) //d
            centreMapOnRunArea() //e
        }
    }
    
    
    /**
    This method is used to centre the map on the run area.
    1. Declares the local variables minLat, minLong, maxLat and maxLong of type Double
    2. IF there is a run
        a. IF there is a location
            b. Set the minLat and maxLat to the firstLocation latitude
            c. Set the minLong and the maxLong to the firstLocation longitude
            d. For each location in the array
                i. Set the currentCoordinate to the coordinate at the current index
               ii. If the currentCoordinate latitude is less than the minLat, set the minLat to the currentCoordinate latitude
              iii. If the currentCoordinate latitude is more than the maxLat, set the maxLat to the currentCoordinate latitude
               iv. If the currentCoordinate longitude is less than the minLong, set the minLong to the currentCoordinate longitude
                v. If the currentCoordinate longitude is more than the maxLong, set the maxLong to the currentCoordinate longitude
            e. Set the centreLat to the middle of the maxLat and minLat
            f. Set the centreLong to the middle of the maxLong and minLong
            g. Create the centreCoord using the centreLat and centreLong
            h. Find the change in latitude, and multiply by 1.1 (to add padding)
            i. Find the change in longitude, and multiply by 1.1 (to add padding)
            j. Create the coordinateSpan using the latDelta and longDelta
            k. Create the region to show on the map using the centreCoord and the coordinateSpan
            l. Set the region currently displayed on the map to the new region
    */
    func centreMapOnRunArea() {
        var minLat, minLong, maxLat, maxLong: Double //1
        
        if let run = run { //2
            if let firstLocation = run.locations.first { //a
                minLat = firstLocation.coordinate.latitude //b
                maxLat = firstLocation.coordinate.latitude
                minLong = firstLocation.coordinate.longitude //c
                maxLong = firstLocation.coordinate.longitude
                
                for var i = 1; i < run.locations.count; i++ { //d
                    let currentCoordinate = run.locations[i].coordinate //i
        
                    if currentCoordinate.latitude < minLat { //ii
                        minLat = currentCoordinate.latitude
                    }
                    if currentCoordinate.latitude > maxLat { //iii
                        maxLat = currentCoordinate.latitude
                    }
                    
                    if currentCoordinate.longitude < minLong { //iv
                        minLong = currentCoordinate.longitude
                    }
                    if currentCoordinate.longitude > maxLong { //v
                        maxLong = currentCoordinate.longitude
                    }
                }
                
                let centreLat = (minLat + maxLat) / 2.0 //e
                let centreLong = (minLong + maxLong) / 2.0 //f
                let centreCoord = CLLocationCoordinate2D(latitude: centreLat, longitude: centreLong) //g
                
                let latDelta = (maxLat - minLat) * 1.1 //h
                let longDelta = (maxLong - minLong) * 1.1 //i
                let coordinateSpan = MKCoordinateSpanMake(latDelta, longDelta) //j
                
                let region = MKCoordinateRegion(center: centreCoord, span: coordinateSpan) //k
                
                self.mapKitView.setRegion(region, animated: true) //l
            }
        }
        
    }

    
    /**
    This method is called by the system whenever there is a request to add an overlay to the MapKit View.
    1. IF the overlay to be added is a MKPolyline
        a. Create the polyline renderer for this overlay
        b. Set the line colour
        c. Set the line width
        d. Return the renderer
    2. Otherwise return nil
    */
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline { //1
            var polylineRenderer = MKPolylineRenderer(overlay: overlay) //a
            polylineRenderer.strokeColor = UIColor.greenColor() //b
            polylineRenderer.lineWidth = 4 //c
            return polylineRenderer //d
        }
        return nil //2
    }
    
    
    /**
    Where there aren't any locations, this method hides the map and adds some filler content.
    */
    func hideMapForNoLocations() {
        self.mapKitView.hidden = true
        //Add filler content
    }

}
