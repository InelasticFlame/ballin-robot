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
    
    func hideMapForNoLocations() {
        self.mapKitView.hidden = true
        //Add filler content
    }
    
    //MARK: - Map Drawing Methods
    
    func drawRouteLineOnMap() {
        if NSUserDefaults.standardUserDefaults().stringForKey("mapStyle") == "SATALITE" {
            mapKitView.mapType = MKMapType.Satellite
        } else if NSUserDefaults.standardUserDefaults().stringForKey("mapStyle") == "HYBRID" {
            mapKitView.mapType = MKMapType.Hybrid
        } else {
            mapKitView.mapType = MKMapType.Standard
        }
        
        if let run = run {
            var coords = Array<CLLocationCoordinate2D>()
            for location in run.locations {
                coords.append(location.coordinate)
            }
            let polyLine = MKPolyline(coordinates: &coords, count: coords.count)
            mapKitView.addOverlay(polyLine)
            centreMapOnRunArea()
        }
    }
    
    
    func centreMapOnRunArea() {
        var minLat, minLong, maxLat, maxLong: Double
        
        if let run = run {
            if let firstLocation = run.locations.first {
                minLat = firstLocation.coordinate.latitude
                maxLat = firstLocation.coordinate.latitude
                minLong = firstLocation.coordinate.longitude
                maxLong = firstLocation.coordinate.longitude
                
                for var i = 1; i < run.locations.count; i++ {
                    let currentCoordinate = run.locations[i].coordinate
        
                    if Double(currentCoordinate.latitude) < minLat {
                        minLat = currentCoordinate.latitude
                    }
                    if Double(currentCoordinate.latitude) > maxLat {
                        maxLat = currentCoordinate.latitude
                    }
                    
                    if Double(currentCoordinate.longitude) < minLong {
                        minLong = currentCoordinate.longitude
                    }
                    if Double(currentCoordinate.longitude) > maxLong {
                        maxLong = currentCoordinate.longitude
                    }
                }
                
                let centreLat = (minLat + maxLat) / 2.0
                let centreLong = (minLong + maxLong) / 2.0
                let centreCoord = CLLocationCoordinate2D(latitude: centreLat, longitude: centreLong)
                
                let latDelta = (maxLat - minLat) * 1.1
                let longDelta = (maxLong - minLong) * 1.1
                let coordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                
                let region = MKCoordinateRegion(center: centreCoord, span: coordinateSpan)
                
                self.mapKitView.setRegion(region, animated: true)
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
