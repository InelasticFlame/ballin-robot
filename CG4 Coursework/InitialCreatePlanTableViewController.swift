//
//  InitialCreatePlanTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 10/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class InitialCreatePlanTableViewController: UITableViewController, UITextFieldDelegate {
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var endDateDetailLabel: UILabel!
    @IBOutlet weak var planNameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var warningLabel: UILabel!
    /* Boolean values that track whether the date picker cells are currently being shown */
    var editingStartDate = false
    var editingEndDate = false
    var showNameWarning = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planNameTextField.delegate = self
        startDatePicker.addTarget(self, action: "updateStartDate:", forControlEvents: .ValueChanged)
        endDatePicker.addTarget(self, action: "updateEndDate:", forControlEvents: .ValueChanged)
        
        startDateDetailLabel.text = Conversions().dateToString(startDatePicker.date)
        endDateDetailLabel.text = Conversions().dateToString(endDatePicker.date)
        endDatePicker.minimumDate = startDatePicker.date
    }
    
    func reloadTableViewCells() {
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
    func updateStartDate(sender: AnyObject) {
        startDateDetailLabel.text = Conversions().dateToString(startDatePicker.date)
        endDatePicker.minimumDate = startDatePicker.date
        endDateDetailLabel.text = Conversions().dateToString(endDatePicker.date)
    }
    
    func updateEndDate(sender: AnyObject) {
        endDateDetailLabel.text = Conversions().dateToString(endDatePicker.date)
    }
    
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
                    reloadTableViewCells()
                    
                } else {
                    editingStartDate = false
                    reloadTableViewCells()
                }
                
            } else if indexPath.row == 2 {
                if !editingEndDate {
                    editingStartDate = false
                    reloadTableViewCells()
                    editingEndDate = true
                    reloadTableViewCells()
                } else {
                    editingEndDate = false
                    reloadTableViewCells()
                }
            }
        }
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let plan = Plan(ID: 1, name: planNameTextField.text, startDate: startDatePicker.date, endDate: endDatePicker.date)
        
        println(plan.active)
    }
    
    /**
    This method is called by the system when the create button is pressed, it checks to see whether it should perform the tranistion to the next view.
    */
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "createPress" {
            if validatePlanName() {
                showNameWarning = false
                reloadTableViewCells()
                return true
            } else {
                showNameWarning = true
                reloadTableViewCells()
                return false
            }
        }
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
