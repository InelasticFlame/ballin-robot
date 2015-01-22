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
    var run: Run?
    @IBOutlet var mapKitView: MKMapView!
    @IBOutlet var overlayView: MapOverlay!
    
    //MARK: - View Methods
    
    /**
    1. IF there is a run
        a. Convert the run distance to a string and set the distanceLabel text as the string
        b. Convert the run score to a string and set the scoreLabel text as the string
        c. Convert the run time to a string and set the timeLabel text as the string
        d. Convert the run date to a string and set the dateLabel text as the string
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        
        if run?.locations.count > 0 {
            drawRouteLineOnMap()
        } else {
            hideMapForNoLocations()
        }
        
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
       fg. Re-order the views so the date and time labels are at the front of the background
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
    
    /**
    Where there aren't any locations, this method hides the map and adds some filler content.
    */
    func hideMapForNoLocations() {
        self.mapKitView.hidden = true
        //Add filler content
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
        if NSUserDefaults.standardUserDefaults().stringForKey("mapStyle") == "SATELLITE" { //1
            mapKitView.mapType = .Satellite
        } else if NSUserDefaults.standardUserDefaults().stringForKey("mapStyle") == "HYBRID" { //2
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
            polylineRenderer.strokeColor = UIColor.redColor() //b
            polylineRenderer.lineWidth = 4 //c
            return polylineRenderer //d
        }
        return nil //2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
