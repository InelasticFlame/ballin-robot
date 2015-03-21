//
//  WeightHistoryViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 04/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit
import HealthKit

class WeightHistoryViewController: UIViewController {

    // MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var graphView: UIView!    
    @IBOutlet weak var greatestWeightLabel: UILabel!
    @IBOutlet weak var lowestWeightLabel: UILabel!
    @IBOutlet weak var weightVariationLabel: UILabel!
    
    //MARK: - Global Variables
    
    private let secondsInDay: Double = 86400 //A global constant that stores the number of seconds in a day
    private let healthStore = HKHealthStore() //A global HKHealthStore that is used to access the HealthKit data store
    
    private var graphCoords = [GraphCoordinate]() //A global mutable array of GraphCoordiantes that stores the graphCoords
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is initially loaded.
    1. Set the startDate as today (by converting the current date (and time) to a date string and back the date becomes the very start of the day)
    2. Set the end date as the very end of the currentDay
    3. Call the function loadWeightForLast7Days passing the startDate and endDate
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var startDate = NSDate(shortDateString: NSDate().shortDateString()) //1
        var endDate = NSDate(timeInterval: secondsInDay, sinceDate: startDate) //2
        loadWeightForLast7Days(startDate, endDate: endDate) //3
    }

    //MARK: - Graph Data Loading
    
    /**
    This method is called to load the data for the graph
    1. Declare the unit to retrieve the weight in
    2. Decalres the weightQuantity
    3. Create a predicate to retrieve the samples between the start and end date
    4. Calls the function retrieveMostRecentSample passing the weight quantity and the predicate
    5. On completion performs the BLOCK A
        a. IF there is an error
            i.Log "Error Reading From HealthKit Datastore: " + the error
        b. IF there is a weight
           ii. Retrieve the double value of the weight for the weightUnit (kilograms)
          iii. Retrieve the main thread
                Z. Create the date string as the startDate to shortestDateString
                Y. Create the charsToRemoveTo as the number of letters - 3 (the last part, /yy)
                X. Create the xStr as the dateStr cutting off the last 3 characters
                W. Create the graph coordinate and add it to the array of graph coordinates
                V. IF there are 7 graph coordinates, call the function drawWeightGraph
        c. IF there is no result
           iv. Retrieve the main thread
                U. Create the date string as the startDate to shortestDateString
                T. Create the charsToRemoveTo as the number of letters - 3 (the last part, /yy)
                S. Create the xStr as the dateStr cutting off the last 3 characters
                R. Create the graph coordinate and add it to the array of graph coordinates
                Q. IF there are 7 graph coordinates, call the function drawWeightGraph
        d. IF there are not 7 graph coords
            v. Set the endDate as the startDate
           vi. Set the startDate to be the endDate -1 day
          vii. Call the function loadWeightForLast7Days
    */
    func loadWeightForLast7Days(startDate: NSDate, endDate: NSDate) {
        var weightUnit = HKUnit(fromMassFormatterUnit: .Kilogram) //1
        
        let weightQuantity = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass) //2
        
        var predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: nil) //3
        
        self.healthStore.retrieveMostRecentSample(weightQuantity, predicate: predicate) { (result, error) -> Void in //4
            /* BLOCK A START */
            //5
            if error != nil { //a
                println("Error Reading From HealthKit Datastore: \(error.localizedDescription)") //i
            }
            
            if let weight = result as? HKQuantitySample { //b
                let doubleWeight = weight.quantity.doubleValueForUnit(weightUnit) //ii
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //iii
                    /* BLOCK B START */
                    let dateStr = startDate.shortestDateString() //Z
                    let charsToRemoveTo = countElements(dateStr) - 3 //Y
                    let xStr = dateStr.substringToIndex(advance(dateStr.startIndex, charsToRemoveTo)) //X
                    
                    self.graphCoords.append(GraphCoordinate(x: xStr, y: CGFloat(doubleWeight))) //W
                    if self.graphCoords.count == 7 { //V
                        self.drawWeightGraph()
                    }
                    /* BLOCK B END */
                })
            }
            
            if result == nil { //c
                dispatch_async(dispatch_get_main_queue(), { () -> Void in //iv
                    /* BLOCK C START */
                    let dateStr = startDate.shortestDateString() //U
                    let charsToRemoveTo = countElements(dateStr) - 3 //T
                    let xStr = dateStr.substringToIndex(advance(dateStr.startIndex, charsToRemoveTo)) //S
                    
                    self.graphCoords.append(GraphCoordinate(x: xStr, y: CGFloat(0))) //R
                    if self.graphCoords.count == 7 { //Q
                        self.drawWeightGraph()
                    }
                    /* BLOCK C END */
                })
            }
            
            if self.graphCoords.count != 7 { //d
                let endDate = startDate //v
                let startDate = NSDate(timeInterval: -self.secondsInDay, sinceDate: endDate) //vi
                self.loadWeightForLast7Days(startDate, endDate: endDate) //vii
            }
            
            /* BLOCK A END */
        }
    }
    
    //MARK: - Graph Drawing
    
    /**
    This method is called if the weight data is successfully loaded from the HealthKit datastore
    1. Declare the local CGFloats greatestWeight and lowestWeight setting their values to the first coordinate in the array of graphCoords
    2. FOR each graphCoordinate after the first
        a. IF it is greater than the greatest weight
            i. Set the greatestWeight to that coordinate
        b. IF if is less than the lowestWeight and non-zero
           ii. Set the lowestWeight to that coordinate
    3. Calculate the weightDelta as the greatestWeight minus the lowestWeight
    4. Set the text of the greatestWeight, lowestWeight and weightVariation labels
    5. Create the frame for the graph as the frame of the graphView but starting at the origin
    6. Create the graph
    7. Set the background colour of the graph to be clear
    8. Add the graph as a subview of the graphView
    */
    func drawWeightGraph() {
        var greatestWeight: CGFloat = graphCoords[0].y //1
        var lowestWeight: CGFloat = graphCoords[0].y
        
        for i in 1...graphCoords.count - 1 { //2
            if graphCoords[i].y > greatestWeight { //a
                greatestWeight = graphCoords[i].y //i
            }
            if graphCoords[i].y < lowestWeight && graphCoords[i].y != 0 { //b
                lowestWeight = graphCoords[i].y //ii
            }
        }
        
        var weightDelta = greatestWeight - lowestWeight //3
        
        greatestWeightLabel.text = NSString(format: "Greatest Weight: %1.2f kg", Double(greatestWeight)) //4
        lowestWeightLabel.text = NSString(format: "Lowest Weight: %1.2f kg", Double(lowestWeight))
        weightVariationLabel.text = NSString(format: "Weight Variation: %1.2f kg", Double(weightDelta))
        
        let frame = CGRect(x: 0, y: 0, width: graphView.frame.width, height: graphView.frame.height) //5
        let graph = Graph(frame: frame, coordinates: graphCoords.reverse()) //6
        graph.backgroundColor = UIColor.clearColor() //7
        
        self.graphView.addSubview(graph) //8
    }
}
