//
//  DurationPicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 05/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class DurationPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return "\(row)h"
        } else if component == 1 {
            return "\(row)m"
        } else {
            return "\(row)s"
        }
        
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

}
