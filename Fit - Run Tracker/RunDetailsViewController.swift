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

    // MARK: - Storyboard Links

    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var overlayView: MapOverlay!

    // MARK: - Global Variables

    var run: Run? //A global optional variable to store the run being displayed as a Run object

    // MARK: - View Life Cycle

    /**
    This method is called by the system when the view is initially loaded. It configures the view ready for display on the interface.
    1. Sets the delegate of the mapKitView to this view controller
    2. IF the run has locations
        a. Calls the function drawRouteLineOnMap
    3. ELSE
        b. Hides the mapKitView
    4. IF there is a run
        c. Convert the run distance to a string and set the distanceLabel text as the string
        d. Convert the run score to a string and set the scoreLabel text as the string
        e. Convert the run time to a string and set the timeLabel text as the string
        f. Gets the run date's short date string and set it as the dateLabel text
        g. Create a UIView that is the same size as the headerOverlay from the overlayView (that is the width the the entire view and a fixed height of 35)
        h. Retrieve the correct colour for the run score at set that as the background of the view
        i. Make the background slightly transparent
        j. Add the view as a subview of the headerOverlay
       kl. Re-order the views so the date and time labels are at the front of the background
        m. Sets the text of the averagePaceLabel to the run pace by converting it to string using the Conversions class
        n. Sets the text of the durationLabel to the run duration by converting it to string using the Conversions class
        o. Add a border to the averagePaceDurationView
        p. Add a border to the mapKitView
        q. Add a border to the headerOverlay
        r. Add a border to the overlayView
    
    Uses the following local variables:
        progressBackground - A UIView that is the background to use for the progress (top) bar
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self //1

        if (run?.locations.count)! > 0 { //2
            drawRouteLineOnMap() //a
        } else { //3
            self.mapKitView.isHidden = true //b
        }

        if let run = run { //4
            overlayView.distanceLabel.text = Conversions().distanceForInterface(distance: run.distance) //c
            overlayView.scoreLabel.text = NSString(format: "%1.1lf pnts", run.score) as String //d
            overlayView.timeLabel.text = run.dateTime.timeString12Hour() //e
            overlayView.dateLabel.text = run.dateTime.shortDateString() //f

            let progressBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width * CGFloat(run.score / 1000), height: 35)) //g
            progressBackground.backgroundColor = run.scoreColour() //h
            progressBackground.alpha = 0.4 //i
            overlayView.headerOverlay.addSubview(progressBackground) //j
            overlayView.headerOverlay.bringSubviewToFront(overlayView.dateLabel) //k
            overlayView.headerOverlay.bringSubviewToFront(overlayView.timeLabel) //l

            overlayView.averagePaceLabel.text = Conversions().averagePaceForInterface(pace: run.pace) //m
            overlayView.durationLabel.text = "Time: " + Conversions().runDurationForInterface(duration: run.duration) //n

            overlayView.averagePaceDurationView.addBorder(borderWidth: 2) //o
            mapKitView.addBorder(borderWidth: 2) //p
            overlayView.headerOverlay.addBorder(borderWidth: 2) //q
            overlayView.addBorder(borderWidth: 2) //r
        }
    }

    // MARK: - Map Drawing Methods

    /**
    This method is used to draw the run route onto the map.
    1. IF there is a run
        a. Create an array of CLLocationCoordinate2D
        b. FOR each location, and the locations coordinates to the array
        c. Create the polyline for the array of coordinates
        d. Add the polyline to the map as an overlay
        e. Call the function centreMapOnRunArea
    
    Uses the following local variables:
        coords - An array of CLLocationCoordinate2D objects that stores the individual coordinates for the location points
        location - The current CLLocation object from the array run.locations
    */
    func drawRouteLineOnMap() {

        if let run = run { //1
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
    
    Uses the following local variables:
        minLat - A double variable that stores the minimum latitude of the set of coordinates
        minLong - A double variable that stores the minimum longitude of the set of coordinates
        maxLat - A double variable that stores the maximum latitude of the set of coordinates
        maxLong - A double variable that stores the maximum longitude of the set of coordinates
        currentCoordNo - An integer variable that tracks the current coordinate number
        centreLat - A constant double that is the midpoint between the maxLat and minLat
        centreLong - A constant double that is the midpoint between the maxLong and minLong
        centreCoord - A constant CLLocationCoordinate2D made from the centre lat and long which is the centre of run
        latDelta - A constant double that is the change in latitude
        longDelta - A constant double that is the change in longitude
        coordinateSpan - A MKCoordinateSpan made from the latitude and longitude delta which is the span to display
        region - A MKCoordinateRegion which is the region for the map kit view to display
    */
    func centreMapOnRunArea() {
        var minLat, minLong, maxLat, maxLong: Double //1

        if let run = run { //2
            if let firstLocation = run.locations.first { //a
                minLat = firstLocation.coordinate.latitude //b
                maxLat = firstLocation.coordinate.latitude
                minLong = firstLocation.coordinate.longitude //c
                maxLong = firstLocation.coordinate.longitude

                for currentCoordNo in 1 ..< run.locations.count { //d
                    let currentCoordinate = run.locations[currentCoordNo].coordinate //i

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
                let coordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta) //j

                let region = MKCoordinateRegion(center: centreCoord, span: coordinateSpan) //k

                self.mapKitView.setRegion(region, animated: true) //l
            }
        }

    }

    /**
    This method is called by the system whenever there is a request to add an overlay to the MapKit View. It creates a renderer to draw the polyline.
    1. IF the overlay to be added is a MKPolyline
        a. Create the polyline renderer for this overlay
        b. Set the line colour
        c. Set the line width
        d. Return the renderer
    2. Otherwise return nil
    
    Uses the following local variables:
        polylineRenderer - A MKPolylineRenderer used to render the polyline
    
    :param: mapView The MKMapView that requested the renderer.
    :param: overlay The MKOverlay object that is to be rendered.
    :returns: The MKOverlayRenderer to use to present the overlay on the map.
    */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        assert(overlay is MKPolyline)

        let polylineRenderer = MKPolylineRenderer(overlay: overlay) //a
        polylineRenderer.strokeColor = UIColor.green //b
        polylineRenderer.lineWidth = 4 //c
        return polylineRenderer //d
    }

}
