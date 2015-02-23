//
//  DurationPicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class DurationPicker: UIPickerView, UIPickerViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else {
            return 60
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return NSString(format: "%ih", row)
        } else if component == 1 {
            return NSString(format: "%02im", row)
        } else {
            return NSString(format: "%02is", row)
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDurationLabel", object: nil)
    }
    
    func selectedDuration() -> (duration: Int, durationStr: String) {
        var duration = 0
        var durationStr = ""
        
        let hours = self.selectedRowInComponent(0)
        let minutes = self.selectedRowInComponent(1)
        let seconds = self.selectedRowInComponent(2)
        
        duration = (hours * 3600) + (minutes * 60) + seconds
        durationStr = NSString(format: "%ih %02im %02is", hours, minutes, seconds)
        
        return (duration, durationStr)
    }
}