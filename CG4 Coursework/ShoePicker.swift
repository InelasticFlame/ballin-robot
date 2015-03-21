//
//  ShoePicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 13/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class ShoePicker: UIPickerView, UIPickerViewDelegate {

    //MARK: - Global Variables
    
    var shoes = [Shoe]() //A global mutable array of shoe objects that stores the shoes displayed in the picker view.
    
    //MARK: - Initialisation
    
    /**
    This method is called when the class initialises. It sets the delegate of the picker view to this class and calls the function loadAllShoes from the Database class to load the shoes for the picker.
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.shoes = Database().loadAllShoes() as [Shoe]
    }
    
    //MARK: - Picker View Data Source
    
    /**
    This method is called by the system in order to set up the picker view. It returns the number of components (columns) in the picker, which is this case is fixed as 1.
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
    This method is called by the system in order to set up the picker view. It returns the number of rows in a specific component; as there is only one component in this picker this function always returns 1 more than the total number of shoes (to allow space for a 'None' option)
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shoes.count + 1
    }
    
    /**
    This method is called by the system in order to set up the picker view. It returns the title for a row in a component. 
    1. IF the current row is the first row
        a. Return "None"
    2. ELSE
        b. Returns the name of the show at the index one less than the row (to make up for the None row)
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if row == 0 { //1
            return "None" //a
        } else { //2
            return shoes[row - 1].name //b
        }
    }
    
    /**
    This method is called by the system when a user selects a row in a component. It posts a notification called UpdateDateDetailLabel passing the user info of a dictionary with the value 'SHOE' stored for the key 'valueChanged'.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDetailLabel", object: nil, userInfo: NSDictionary(object: "SHOE", forKey: "valueChanged"))
    }
    
    /**
    This method is called to return the shoe that is currently selected in the picker view. It has an option return of a Shoe object (this means it could return nil - no shoe selected -> "None" is selected)
    1. Declares the local integer variable selectedShoe and sets its value equal to the selected row in the first (only) component.
    2. IF the selected row is 0
        a. Return nil
    3. ELSE
        b. Return the shoe that is at the index one less than the selected row (to make up for the None row)
    */
    func selectedShoe() -> Shoe? {
        let selectedRow = self.selectedRowInComponent(0) //1
        
        if selectedRow == 0 { //2
            return nil //a
        } else { //3
            return shoes[selectedRow - 1] //b
        }
    }

}
