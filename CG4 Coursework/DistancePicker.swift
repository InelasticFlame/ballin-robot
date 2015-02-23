//
//  DistancePicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class DistancePicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return 2
        } else {
            return 100
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return "\(row)"
        } else if component == 1 {
            return NSString(format: ".%02i", row)
        } else {
            if row == 0 {
                return "mi"
            } else {
                return "km"
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDistanceLabel", object: nil)
    }
    
    func selectedDistance() -> (distance: Double, distanceStr: String) {
        var distance = 0.00
        var distanceStr = ""
        
        if self.selectedRowInComponent(2) == 0 {
            let miles = self.selectedRowInComponent(0)
            let tenthsMiles = self.selectedRowInComponent(1)
            
            distance = Double(miles) + (Double(tenthsMiles)/100)
            distanceStr = "\(distance) mi"
        } else {
            let kilometres = self.selectedRowInComponent(0)
            let tenthsKilometres = self.selectedRowInComponent(1)
            
            let totalKmDistance = Double(kilometres) + (Double(tenthsKilometres)/100)
            
            distance = Conversions().kmToMiles * totalKmDistance
            distanceStr = "\(totalKmDistance) km"
        }
        
        return (distance, distanceStr)
    }
}