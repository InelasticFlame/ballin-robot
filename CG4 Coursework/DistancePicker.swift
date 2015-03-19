//
//  DistancePicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class DistancePicker: UIPickerView, UIPickerViewDelegate {

    /**
    This method is called when the class initialises. It sets the delegate of the picker view to this class.
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }

    //MARK: - Picker View Data Source
    
    /**
    This method is called by the system in order to set up the picker view. It returns the number of components (columns) in the picker, which is this case is fixed as 3.
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    /**
    This method is called by the system in order to set up the picker view. It returns the number of rows in a specific component; IF the component is the last component return 2 (for miles or km), otherwise it returns 100 (for 0 to 99 miles or hundreths of a mile)
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return 2
        } else {
            return 100
        }
    }
    
    /**
    This method is called by the system in order to set up the picker view. It returns the title for a row in a component.
    1. IF the component is the first component
        a. Return the row number as string
    2. ELSE IF the component is the second
        b. Return the row number as a string in the form '.ROW' using 2 digits (e.g. 2 would be 02)
    3. ELSE
        c. IF the row is the first
            i. Return 'mi'
        d. ELSE
            i. Return 'km'
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 { //1
            return "\(row)" //a //miles
        } else if component == 1 { //2
            return NSString(format: ".%02i", row) //b //hundreths of a mile
        } else { //3
            //units
            if row == 0 { //c
                return "mi" //i
            } else { //d
                return "km" //i
            }
        }
    }
    
    /**
    This method is called by the system when a user selects a row in a component. It posts a notification called UpdateDateDetailLabel passing the user info of a dictionary with the value 'DISTANCE' stored for the key 'valueChanged'.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDetailLabel", object: nil, userInfo: NSDictionary(object: "DISTANCE", forKey: "valueChanged"))
    }
    
    /**
    This method is called to return the selected distance. It returns the distance as a double (in miles) and the distance as a string (in the form DISTANCE unit).
    1. Declares the local double variable distance
    2. Delcares the local string variable distanceStr
    3. IF the selected row in the last (unit) component is the first
        a. Declares the local double constant miles as the selected row in the first component
        b. Declares the local double constant hundrethsMiles as the selected row in the second component
        c. Sets the distance equal to the miles plus the hundrethsMile divided by 100
        d. Sets the distance string as the 'DISTANCE mi"
    4. ELSE
        a. Declares the local double constant kilometres as the selected row in the first component
        b. Declares the local double constant hundrethsKilometres as the selected row in the second component
        c. Declares the local double constant totalKmDistance as the kilometres plus the hundrethsKilometres divided by 100
        d. Sets the distance equal to the totalKmDistance converted to miles
        e. Sets the distance string as the "totalKmDistance km"
    */
    func selectedDistance() -> (distance: Double, distanceStr: String) {
        var distance = 0.00
        var distanceStr = ""
        
        if self.selectedRowInComponent(2) == 0 {
            //The picker is in MILES
            let miles = Double(self.selectedRowInComponent(0))
            let hundrethsMiles = Double(self.selectedRowInComponent(1))
            
            distance = miles + (hundrethsMiles/100)
            distanceStr = "\(distance) mi"
        } else {
            //The picker is in KILOMETRES
            let kilometres = Double(self.selectedRowInComponent(0))
            let hundrethsKilometres = Double(self.selectedRowInComponent(1))
            
            let totalKmDistance = kilometres + (hundrethsKilometres/100)
            
            distance = Conversions().kmToMiles * totalKmDistance
            distanceStr = "\(totalKmDistance) km"
        }
        
        return (distance, distanceStr)
    }
    
    /**
    This method is called to set the picker to a certain distance (used in the Add New Run View Controller)
    1. Declares the local integer constant miles as the integer value of the distance
    2. Declares the local integer constant hundrethsMiles as the (distance minus the number of miles) * 100 converted to an integer
    3. Sets the selected row in the first component as the number of miles
    4. Sets the selected row in the second component as the number of hundreths of miles
    5. Sets the selected row in the third component as the 'mi' unit
    */
    func setDistance(distance: Double) {
        let miles = Int(distance) //1
        let hundrethsMiles = Int((distance - Double(miles)) * 100) //2
        
        self.selectRow(miles, inComponent: 0, animated: false) //3
        self.selectRow(hundrethsMiles, inComponent: 1, animated: false) //4
        self.selectRow(0, inComponent: 2, animated: false) //5
    }
}