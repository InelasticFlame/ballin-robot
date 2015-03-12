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
    
    private let secondsInDay: Double = 86400
    private var graphCoords = [GraphCoordinate]()
    var healthStore = HKHealthStore()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var startDate = NSDate(shortDateString: NSDate().shortDateString()) //The date to retrieve from
        var endDate = NSDate(timeInterval: secondsInDay, sinceDate: startDate)
        loadWeightForLast7Days(startDate, endDate: endDate)
    }

    
    //Loads in random order.
    func loadWeightForLast7Days(startDate: NSDate, endDate: NSDate) {
        var weightUnit = HKUnit(fromMassFormatterUnit: .Kilogram)
        
        let weightQuantity = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        var predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: nil)
        
        self.healthStore.retrieveMostRecentSample(weightQuantity, predicate: predicate) { (result, error) -> Void in
            /* BLOCK START */
            if (error != nil) {
                println("Error Reading From HealthKit Datastore: \(error.localizedDescription)")
            }
            
            if let weight = result as? HKQuantitySample {
                let doubleWeight = weight.quantity.doubleValueForUnit(weightUnit)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    /* BLOCK START */
                    self.graphCoords.append(GraphCoordinate(x: startDate.shortDateString(), y: CGFloat(doubleWeight)))
                    if self.graphCoords.count == 7 {
                        self.drawWeightGraph()
                    }
                    /* BLOCK END */
                })
            }
            
            if result == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    /* BLOCK START */
                    self.graphCoords.append(GraphCoordinate(x: startDate.shortDateString(), y: CGFloat(0)))
                    if self.graphCoords.count == 7 {
                        self.drawWeightGraph()
                    }
                    /* BLOCK END */
                })
            }
            
            if self.graphCoords.count != 7 {
                let endDate = startDate
                let startDate = NSDate(timeInterval: -self.secondsInDay, sinceDate: endDate)
                self.loadWeightForLast7Days(startDate, endDate: endDate)
            }
            
            /* BLOCK END */
        }
    }
    
    func drawWeightGraph() {
        var greatestWeight: CGFloat = graphCoords[0].y
        var lowestWeight: CGFloat = graphCoords[0].y
        
        for i in 1...graphCoords.count - 1 {
            if graphCoords[i].y > greatestWeight {
                greatestWeight = graphCoords[i].y
            }
            if graphCoords[i].y < lowestWeight && graphCoords[i].y != 0 {
                lowestWeight = graphCoords[i].y
            }
        }
        
        var weightDelta = greatestWeight - lowestWeight
        
        greatestWeightLabel.text = NSString(format: "Greatest Weight: %1.2f kg", Double(greatestWeight))
        lowestWeightLabel.text = NSString(format: "Lowest Weight: %1.2f kg", Double(lowestWeight))
        weightVariationLabel.text = NSString(format: "Weight Variation: %1.2f kg", Double(weightDelta))
        
        let frame = CGRect(x: 0, y: 0, width: graphView.frame.width, height: graphView.frame.height)
        let graph = Graph(frame: frame, graphStyle: .Line, coordinates: graphCoords.reverse())
        graph.backgroundColor = UIColor.clearColor()
        
        self.graphView.addSubview(graph)
    }
}
