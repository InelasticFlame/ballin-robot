//
//  PacePicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PacePicker: UIPickerView, UIPickerViewDelegate {

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
            return 60
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return NSString(format: "%im", row)
        } else if component == 1 {
            return NSString(format: "%02is", row)
        } else {
            if row == 0 {
                return "/mi"
            } else {
                return "/km"
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDetailLabel", object: nil, userInfo: NSDictionary(object: "PACE", forKey: "valueChanged"))
    }
    
    func selectedPace() -> (pace: Int, paceStr: String) {
        var pace = 0
        var paceStr = ""
        
        if self.selectedRowInComponent(2) == 0 {
            let minutesPerMile = self.selectedRowInComponent(0)
            let secondsPerMile = self.selectedRowInComponent(1)
            
            pace = (60 * minutesPerMile) + secondsPerMile
            paceStr = NSString(format: "%02i:%02i /mi", minutesPerMile, secondsPerMile)
            
        } else {
            let minutesPerKm = self.selectedRowInComponent(0)
            let secondsPerKm = self.selectedRowInComponent(1)
            
            let doublePace = (60.0 * (Double(minutesPerKm)) * Conversions().kmToMiles) + ((Double(secondsPerKm)) * Conversions().kmToMiles)
            pace = Int(doublePace)
            paceStr = NSString(format: "%02i:%02i /km", minutesPerKm, secondsPerKm)
        }
        
        return (pace, paceStr)
    }
    
    func setPace(pace: Int) {
        let minutes = pace / 60
        let seconds = pace % 60
        
        self.selectRow(minutes, inComponent: 0, animated: false)
        self.selectRow(seconds, inComponent: 1, animated: false)
        self.selectRow(0, inComponent: 2, animated: false)
    }
}
