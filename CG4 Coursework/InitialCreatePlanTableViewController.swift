//
//  InitialCreatePlanTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 10/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class InitialCreatePlanTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    //MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var endDateDetailLabel: UILabel!
    @IBOutlet weak var planNameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var warningLabel: UILabel!
    
    //MARK: - Global Variables
    /* Boolean values that track whether the date picker cells are currently being shown */
    var editingStartDate = false
    var editingEndDate = false
    var showNameWarning = false
    
    
    //MARK: - View Life Cycle
    /**
    This method is called by the system when the view initially loads.
    1. Sets the delegate of the planNameTextField to this viewController
    2. Adds a target to each date picker that calls the appropriate method whenever the date picker has its value changed
    3. Updates the text of the startDateDetailLabel and endDateDetailLabel to the currently selected value from the date picker, using the date formatter from the Conversions class
    4. Sets the minimum date for the endDatePicker to be the currently selected date of the start date picker
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planNameTextField.delegate = self //1
        startDatePicker.addTarget(self, action: "updateStartDate:", forControlEvents: .ValueChanged) //2
        endDatePicker.addTarget(self, action: "updateEndDate:", forControlEvents: .ValueChanged)
        
        startDateDetailLabel.text = Conversions().dateToString(startDatePicker.date) //3
        endDateDetailLabel.text = Conversions().dateToString(endDatePicker.date) //4
        endDatePicker.minimumDate = startDatePicker.date //5
    }
    
    //MARK: - Text Field
    
    /**
    This methid is called by the system when a user presses the return button on the keyboard whilst inputting into the text field.
    1. Dismisses the keyboard by removing the textField as the first responder for the view (the focus)
    2. Returns false
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() //1
        
        return false //2
    }
    
    //MARK: - Date Picker Control
    
    func updateStartDate(sender: AnyObject) {
        startDateDetailLabel.text = Conversions().dateToString(startDatePicker.date)
        endDatePicker.minimumDate = startDatePicker.date
        endDateDetailLabel.text = Conversions().dateToString(endDatePicker.date)
    }
    
    func updateEndDate(sender: AnyObject) {
        endDateDetailLabel.text = Conversions().dateToString(endDatePicker.date)
    }
    
    //MARK: - TableView
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                if editingStartDate {
                    return 162
                } else {
                    return 0
                }
            } else if indexPath.row == 3 {
                if editingEndDate {
                    return 162
                } else {
                    return 0
                }
            }
        } else if indexPath.section == 0 && indexPath.row == 1 {
            if showNameWarning {
                return 44
            } else {
                return 0
            }
        }
        
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if !editingStartDate {
                    editingEndDate = false
                    reloadTableViewCells()
                    editingStartDate = true
                } else {
                    editingStartDate = false
                }
                
            } else if indexPath.row == 2 {
                if !editingEndDate {
                    editingStartDate = false
                    reloadTableViewCells()
                    editingEndDate = true
                } else {
                    editingEndDate = false
                }
            }
        }
        
        reloadTableViewCells()
    }
    
    func reloadTableViewCells() {
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    /**
    This method checks that a plan name is valid.
    1. Declares and initialises the regular expression to check the string against; the string is valid for all letters A to Z (in both upper and lower case), all numbers and the symbols ?!.
    2. Declares and initialises the local variable planName, setting its value to the text in the planNameTextField with all spaces removed.
    3. IF the planName contains nothing
        a. Sets the text of the warning label
        b. Returns false
    4. Declares and creates a NSPredicate to test the string against the regular expression, IF it is created
        a. Sets the text of the warning label
        b. Returns the evaluation of the NSPredicate on the planName
    5. In the default case, returns false
    */
    func validatePlanName() -> Bool {
        let regEx = "[A-Z0-9a-z?!.]*" //1
        let planName = planNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil) //2
        
        if planName.isEmpty { //3
            warningLabel.text = "A plan name must contain at least 1 letter or number." //a
            return false //b
        } else if let stringTester = NSPredicate(format: "SELF MATCHES %@", regEx) { //4
            warningLabel.text = "A plan name must only contain letters, numbers or ?!." //a
            return stringTester.evaluateWithObject(planName) //b
        }
        
        return false //5
    }
    

    // MARK: - Navigation

    /**
    This method is called by the system when is segue is about to be performed.
    1. IF the segue being performed is called "createPress"
        a. Calls the function createNewPlanWithName from the Database class, IF it returns a plan
            i. IF the destinationViewController for the segue is a CreatePlanViewController
                ii. Set the plan of the destinationViewController to the plan returned from the database
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createPress" { //1
            if let plan = Database().createNewPlanWithName(planNameTextField.text, startDate: startDatePicker.date, andEndDate:endDatePicker.date) as? Plan { //a
                
                if let destinationVC = segue.destinationViewController as? CreatePlanViewController { //i
                    destinationVC.plan = plan //ii
                }
            }
        }
    }
    
    /**
    This method is called by the system when the create button is pressed, it checks to see whether it should perform the tranistion to the next view.
    1. IF the segue to be performed is called "createPress"
        a. Calls the function validatePlanName, IF it returns true
            i. Returns true
        b. ELSE
            i. Sets showNameWarning to true
           ii. Calls the function reloadTableViewCells
          iii. Returns false
    2. In the default case returns true
    */
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "createPress" { //1
            if validatePlanName() { //a
                return true //i
            } else { //b
                showNameWarning = true //i
                reloadTableViewCells() //ii
                return false //iii
            }
        }
        
        return true //2
    }
}
