//
//  PlanRepetitionPicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 18/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PlanRepetitionPicker: UIPickerView, UIPickerViewDelegate {

    let repeats = ["Never", "Every Day", "Every Week", "Every 2 Weeks", "Every Month"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return repeats.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return repeats[row]
    }
}
