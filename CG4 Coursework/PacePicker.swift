//
//  PacePicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PacePicker: UIPickerView, UIPickerViewDelegate {

    /**
    This method is called when the class initialises. It sets the delegate of the picker view to this class.

    :param: coder An NSCoder that is used to unarchive the class.
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    //MARK: - Picker View Data Source
    
    /**
    This method is called by the system in order to set up the picker view. It returns the number of components (columns) in the picker, which is this case is fixed as 3.
    
    :param: pickerView The UIPickerView requesting the number of components.
    :returns: The number of components.
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    /**
    This method is called by the system in order to set up the picker view. It returns the number of rows in a specific component; IF the component is the last component return 2 (for per miles or per km), otherwise it returns 60 (for 0 to 59 minutes or seconds)
    
    :param: pickerView The UIPickerView requesting the number of components.
    :param: component An integer identifying the component the number of rows should be returned for.
    :returns: The number of rows in the component.
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return 2
        } else {
            return 60
        }
    }
    
    /**
    This method is called by the system in order to set up the picker view. It returns the title for a row in a component.
    1. IF the component is the first component
        a. Return the row number as string in the form  'ROWm'
    2. ELSE IF the component is the second
        b. Return the row number as a string in the form 'ROWs' using 2 digits (e.g. 2 would be 02)
    3. ELSE
        c. IF the row is the first
            i. Return '/mi'
        d. ELSE
            i. Return '/km'
    
    :param: pickerView The UIPickerView requesting the number of components.
    :param: row An integer identifying the row for which the title should be returned for.
    :param: component An integer identifying the component that the row is in.
    :returns: A string that is the title for the row.
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 { //1
            return NSString(format: "%im", row) //a //minutes
        } else if component == 1 { //2
            return NSString(format: "%02is", row) //b //seconds
        } else { //3
            //unit
            if row == 0 { //c
                return "/mi" //i
            } else { //d
                return "/km" //i
            }
        }
    }
    
    /**
    This method is called by the system when a user selects a row in a component. It posts a notification called UpdateDateDetailLabel passing the user info of a dictionary with the value 'PACE' stored for the key 'valueChanged'.
    
    :param: pickerView The UIPickerView informing the delegate that a row has been selected.
    :param: row An integer identifying the row which was selected.
    :param: component An integer identifying the component that the row is in.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDetailLabel", object: nil, userInfo: NSDictionary(object: "PACE", forKey: "valueChanged"))
    }
    
    /**
    This method is called to return the selected pace. It returns the pace as an integer (in secs/mile) and the distance as a string (in the form MM:ss /unit)
    1. Declares the local integer variable pace
    2. Declares the local string variable paceStr
    3. IF the row selected in the last component is the first row
        a. Declares the local integer constant minutesPerMile as the row selected in the first component
        b. Declares the local integer constant secondsPerMile as the row selected in the second component
        c. Sets the pace to 60 * minutesPerMile added to the seconds per mile (so the result is in seconds)
        d. Sets the paceStr to "MM:ss /mi" where the minutesPerMile and secondsPerMile use 2 digits (e.g. 2 is 02)
    4. ELSE
        a. Declares the local integer constant minutesPerKm as the row selected in the first component
        b. Declares the local integer constant secondsPerKm as the row selected in the second component
        c. Declares the local double constant as 60 * the double of minutesPerKm converted to miles (1 over the conversion as it is PER km unit) added to the seconds converted to miles
        d. Sets the pace to the integer value of the doublePace
        e. Sets the pace string to "MM:ss /km" where the minutesPerKm and secondsPerKm use 2 digits (e.g. 2 is 02)
    5. Returns the pace and the paceStr
    
    Uses the following local variables:
        pace - An integer variable that stores the selected pace
        paceStr - A string variable that stores the pace as a string
        minutesPerMile - An integer constant that stores the number of minutes per mile
        secondsPerMile - An integer constant that stores the seconds part of the pace
        minutesPerKm - An integer constant that stores the number of minutes per kilometer
        secondsPerKm - An integer constant that stores the seconds part per kilometer
        doublePace - A double constant that stores the pace in seconds per mile
    
    :returns: pace - An integer value that is the selected pace in seconds per mile.
    :returns: paceStr - The pace that is selected as a string in the user's chosen unit.
    */
    func selectedPace() -> (pace: Int, paceStr: String) {
        var pace = 0 //1
        var paceStr = "" //2
        
        if self.selectedRowInComponent(2) == 0 { //3
            let minutesPerMile = self.selectedRowInComponent(0) //a
            let secondsPerMile = self.selectedRowInComponent(1) //b
            
            pace = (60 * minutesPerMile) + secondsPerMile //c
            paceStr = NSString(format: "%02i:%02i /mi", minutesPerMile, secondsPerMile) //d
            
        } else { //4
            let minutesPerKm = self.selectedRowInComponent(0) //a
            let secondsPerKm = self.selectedRowInComponent(1) //b
            
            let doublePace = (60.0 * (Double(minutesPerKm)) * (1/Conversions().kmToMiles)) + ((Double(secondsPerKm)) * (1/Conversions().kmToMiles)) //d
            
            pace = Int(doublePace) //e
            paceStr = NSString(format: "%02i:%02i /km", minutesPerKm, secondsPerKm) //f
        }
        
        return (pace, paceStr) //5
    }
    
    /**
    This method is called to set the picker to a certain pace (used in the Add New Run View Controller)
    1. Declares the local integer constant minutes as the pace divided by 60
    2. Declares the local integer constant seconds as the pace modulus 60
    3. Selects the row of the minutes in the first component
    4. Selects the row of the seconds in the second component
    5. Selects the first row in the last component
    
    Uses the following local variables:
        minutes - A constant integer that is the number of seconds per mile
        seconds - A constant integer that is the seconds part of the pace per mile
    
    :params: pace The pace to set the picker to as an integer in seconds per mile.
    */
    func setPace(pace: Int) {
        let minutes = pace / 60
        let seconds = pace % 60
        
        self.selectRow(minutes, inComponent: 0, animated: false)
        self.selectRow(seconds, inComponent: 1, animated: false)
        self.selectRow(0, inComponent: 2, animated: false)
    }
}
