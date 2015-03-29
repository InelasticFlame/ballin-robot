//
//  DurationPicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class DurationPicker: UIPickerView, UIPickerViewDelegate {

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
    This method is called by the system in order to set up the picker view. It returns the number of rows in a specific component; IF the component is the first component return 24 (for 0 to 23 hours), otherwise it returns 60 (for 0 to 59 minutes or seconds)
    
    :param: pickerView The UIPickerView requesting the number of components.
    :param: component An integer identifying the component the number of rows should be returned for.
    :returns: The number of rows in the component.
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else {
            return 60
        }
    }
    
    /**
    This method is called by the system in order to set up the picker view. It returns the title for a row in a component.
    1. IF the component is the first component
        a. Return the row number followed by 'h'
    2. ELSE IF the component is the second
        b. Return the row number followed by 'm', using 2 digits for the row number (e.g. 2 will be 02m)
    3. ELSE
        c. Return the row number followed by 's', using 2 digits for the row number
    
    :param: pickerView The UIPickerView requesting the number of components.
    :param: row An integer identifying the row for which the title should be returned for.
    :param: component An integer identifying the component that the row is in.
    :returns: A string that is the title for the row.
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 { //1
            return NSString(format: "%ih", row) //a //hours
        } else if component == 1 { //2
            return NSString(format: "%02im", row) //b //minutes
        } else { //3
            return NSString(format: "%02is", row) //c //seconds
        }
    }
    
    /**
    This method is called by the system when a user selects a row in a component. It posts a notification called UpdateDateDetailLabel passing the user info of a dictionary with the value 'DURATION' stored for the key 'valueChanged'.
    
    :param: pickerView The UIPickerView informing the delegate that a row has been selected.
    :param: row An integer identifying the row which was selected.
    :param: component An integer identifying the component that the row is in.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDetailLabel", object: nil, userInfo: NSDictionary(object: "DURATION", forKey: "valueChanged"))
    }
    
    /**
    This method is called to return the selected duration. It returns the duration as an integer (in seconds) and the duration as a string (in the form h:mm:ss)
    1. Declares the local integer variable duration
    2. Declares the local string variable durationStr
    3. Declares the local constant hours and sets its value to the selected row in the first component
    4. Declares the local constant minutes and sets its value to the selected row in the second component
    5. Declares the local constant seconds and sets its value to the selected row in the third component
    6. Calculates the duration in seconds as the number of hours * 3600 added to the number of minutes * 60 and added to the number of seconds
    7. Sets the durationStr to hours, minutes and seconds in the form HOURSh MINUTESm SECONDSs
    8. Returns the duration and the durationStr
    
    Uses the following local variables:
        duration - An integer variable that stores the duration selected
        durationStr - A string variable that stores the selected duration as a string
        hours - An integer constant that is the number of hours selected
        minutes - An integer constant that is the number of minutes selected
        seconds - An integer constant that is the number of seconds selected
    
    :returns: duration - The duration selected as an integer in seconds.
    :returns: durationStr - The duration selected as a string in the form HH:mm:ss
    */
    func selectedDuration() -> (duration: Int, durationStr: String) {
        var duration = 0 //1
        var durationStr = "" //2
        
        let hours = self.selectedRowInComponent(0) //3
        let minutes = self.selectedRowInComponent(1) //4
        let seconds = self.selectedRowInComponent(2) //5
        
        duration = (hours * 3600) + (minutes * 60) + seconds //6
        durationStr = NSString(format: "%ih %02im %02is", hours, minutes, seconds) //7
        
        return (duration, durationStr) //8
    }
    
    /**
    This method is called to set the picker to a certain duration (used in the Add New Run View Controller)
    1. Declares the local integer constant hours setting its value to the duration divided by 3600 (the number of hours)
    2. Declares the local integer constant remainingSeconds settings its value to the duration modulus 3600 (the number of seconds there are without the hours)
    3. Declares the local integer constant minutes as the remaining seconds divided by 60
    4. Declares the local integer constant seconds as the duration modulus 60
    5. Sets the selected row in the first column to the number of hours
    6. Sets the selected row in the second column to the number of minutes
    7. Sets the selected row in the third column to the number of seconds
    
    Uses the following local variables:
        hours - An integer constant that is the number of hours ran for
        remainingSeconds - An integer constant that is the number of leftover seconds
        minutes - An integer constant that is the number of minutes ran for
        seconds - An integer constant that is the number of seconds ran for
    
    :param: duration The duration to set the picker to as an integer in seconds.
    */
    func setDuration(duration: Int) {
        let hours = duration/3600
        let remainingSeconds = duration % 3600
        let minutes = remainingSeconds/60
        let seconds = duration % 60
        
        self.selectRow(hours, inComponent: 0, animated: false)
        self.selectRow(minutes, inComponent: 1, animated: false)
        self.selectRow(seconds, inComponent: 2, animated: false)
    }
}