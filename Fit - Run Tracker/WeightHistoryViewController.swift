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

    // MARK: - Global Variables

    private let healthStore = HKHealthStore() //A global HKHealthStore that is used to access the HealthKit data store

    private var graphCoords = [GraphCoordinate]() //A global mutable array of GraphCoordiantes that stores the graphCoords

    // MARK: - View Life Cycle

    /**
    This method is called by the system when the view is initially loaded. It sets the view to its initial state.
    1. Set the startDate as today (by converting the current date (and time) to a date string and back the date becomes the very start of the day)
    2. Set the end date as the very end of the currentDay
    3. Call the function loadWeightForLast7Days passing the startDate and endDate
    
    Uses the following local variables:
        startDate - A constant NSDate that is the start of the first day to retrieve
        endDate - A constant NSDate that is the end of the first day to retrieve
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        let startDate = Date().startOfDay()
        let endDate = startDate.endOfDay()
        loadWeightForLast7Days(startDate: startDate, endDate: endDate) //3
    }

    // MARK: - Graph Data Loading

    /**
    This method is called to load the data for the graph.
    1. Declare the unit to retrieve the weight in
    2. Declares the weightQuantity
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
    
    Uses the following local variables:
        weightUnit - A constant HKUnit that is the unit to retrieve the weight data in
        weightQuantity - A constant HKQuantityType that is the quantity to retrieve from the health kit datastore (body mass)
        predicate - A constant NSPredicate to filter the query using
    The block use the following variables:
        doubleWeight - A constant double that is the user's weight converted to a double from the weight quantity sample
        dateStr - A constant string that is the start date as a shortest date string
        charsToRemoveTo - A constant integer that is the index to cut the string to (3 chars removed for the year section of the date)
        xStr - A constant string that is the dateStr cut to the charsToRemoveTo
        startDate - A constant NSDate that is the start of the next day to retrieve
        endDate - A constant NSDate that is the end of the next day to retrieve
    
    :param: startDate The start of the first day to retrieve the weight data from.
    :param: endDate The end of the first day to retrieve the weight data from.
    */
    func loadWeightForLast7Days(startDate: Date, endDate: Date) {
        let weightUnit = HKUnit(from: .kilogram) //1

        let weightQuantity = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) //2

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: []) //3

        self.healthStore.retrieveMostRecentSample(sampleType: weightQuantity!, predicate: predicate) { (result, error) -> Void in //4
            /* BLOCK A START */
            //5
            if error != nil { //a
                print("Error Reading From HealthKit Datastore: \(error!.localizedDescription)") //i
            }

            if let weight = result as? HKQuantitySample { //b
                let doubleWeight = weight.quantity.doubleValue(for: weightUnit) //ii

                DispatchQueue.main.async {
                    /* BLOCK B START */
                    let dateStr = startDate.toShortestDateString //Z
                    let charsToRemoveTo = dateStr.index(dateStr.endIndex, offsetBy: -3)
                    let xStr = dateStr.substring(to: charsToRemoveTo) //X

                    self.graphCoords.append(GraphCoordinate(x: xStr, y: CGFloat(doubleWeight))) //W
                    if self.graphCoords.count == 7 { //V
                        self.drawWeightGraph()
                    }
                    /* BLOCK B END */
                }
            }

            if result == nil { //c
                DispatchQueue.main.async {
                    /* BLOCK C START */
                    let dateStr = startDate.toShortestDateString //U
                    let charsToRemoveTo = dateStr.index(dateStr.endIndex, offsetBy: -3)
                    let xStr = dateStr.substring(to: charsToRemoveTo) //X

                    self.graphCoords.append(GraphCoordinate(x: xStr, y: CGFloat(0))) //R
                    if self.graphCoords.count == 7 { //Q
                        self.drawWeightGraph()
                    }
                    /* BLOCK C END */
                }
            }

            if self.graphCoords.count != 7 { //d
                let endDate = startDate //v
                let startDate = endDate.subtract(1.days) //vi
                self.loadWeightForLast7Days(startDate: startDate, endDate: endDate) //vii
            }

            /* BLOCK A END */
        }
    }

    // MARK: - Graph Drawing

    /**
    This method is called if the weight data is successfully loaded from the HealthKit datastore. It draws the weight against time graph for the data loaded.
    1. Declare the local CGFloats greatestWeight and lowestWeight setting their values to the first coordinate in the array of graphCoords
    2. FOR each graphCoordinate after the first
        a. IF it is greater than the greatest weight
            i. Set the greatestWeight to that coordinate
        b. IF if is less than the lowestWeight and non-zero
           ii. Set the lowestWeight to that coordinate
    3. Calculate the weightDelta as the greatestWeight minus the lowestWeight
    4. Set the text of the greatestWeight, lowestWeight and weightVariation labels
    5. Create the frame for the graph as the frame of the graphView but starting at the origin
    6. Create the graph (the array is reversed as the array has the weights with the newest at the start rather than the end)
    7. Set the background colour of the graph to be clear
    8. Add the graph as a subview of the graphView
    
    Uses the following local variables:
        greatestWeight - A variable CGFloat that is the user's greatest weight over the 7 day period
        lowestWeight - A variable CGFloat that is the user's least weight over the 7 day period
        weightDelta - A constant CGFloat that is the weight variation over the 7 day period
        frame - A constant CGRect that is the frame to use for the graph
        graph - The Graph of weight against time that is to be displayed on the interface
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

        let weightDelta = greatestWeight - lowestWeight //3

        greatestWeightLabel.text = NSString(format: "Greatest Weight: %1.2f kg", Double(greatestWeight)) as String //4
        lowestWeightLabel.text = NSString(format: "Lowest Weight: %1.2f kg", Double(lowestWeight)) as String
        weightVariationLabel.text = NSString(format: "Weight Variation: %1.2f kg", Double(weightDelta)) as String

        let frame = CGRect(x: 0, y: 0, width: graphView.frame.width, height: graphView.frame.height) //5
        let graph = Graph(frame: frame, coordinates: graphCoords.reversed()) //6
        graph.backgroundColor = UIColor.clear //7

        self.graphView.addSubview(graph) //8
    }
}
