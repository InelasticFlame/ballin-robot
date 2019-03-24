//
//  Plan.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Plan: NSObject {

    //MARK: - Properties
    
    private(set) var ID: Int //A property that stores the ID of the Plan; private(set) means that it can only be written from inside this class, but can be read by any class (this is to ensure Database integrity by prevent the unique ID being changed)
    var name: String //A string property that stores the name of the plan
    var startDate: NSDate //An NSDate property that stores the startDate of the plan
    var endDate: NSDate //An NSDate property that stores the endDate of the plan
    var active = false //A boolean property that stores whether the plan is active or not
    var plannedRuns = [PlannedRun]() //An array of PlannedRun objects that stores the planned runs for the plan
    
    //MARK: - Initialisation
    
    /**
    Called to initialise the class, sets the properties of the Shoe to the passed values.
    1. Calls the local function checkIfActive
    2. Calls the local function loadPlannedRuns
    
    :param: ID The ID of the Plan object.
    :param: name The name of the Plan as a string.
    :param: startDate The date that the Plan starts as an NSDate.
    :param: endDate The date that the Plan ends as an NSDate.
    */
    init(ID: Int, name: String, startDate: NSDate, endDate: NSDate) {
        self.ID = ID
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        
        super.init()
        self.checkIfActive() //1
        self.loadPlannedRuns() //2
    }
    
    /**
    This method is used to check if a plan is currently active.
    1. Declares the local variable today an NSDate object, which is the current date and time
    2. Declares the local variable endDate an NSDate object, which is the plan endDate plus just less than 1 day in seconds (so it comes to the very end of the end day)
    3. IF the earlier date of today and the startDate is the startDate and the latest date of the today and the endDate is the endDate
        a. Set the plan as active
    4. ELSE set the plan as inactive
    
    Uses the following local variables:
        today - A constant NSDate that represents today
        endDate - A constant NSDate that is the very end of the plan end date day
    */
    func checkIfActive() {
        let today = NSDate()
        let endDate = self.endDate.addingTimeInterval(86399)
        
        if today.earlierDate(startDate as Date) == startDate as Date && today.laterDate(endDate as Date) == endDate as Date {
            self.active = true
        } else {
            self.active = false
        }
    }
    
    /**
    This method loads the planned runs for the plan.
    1. Loads the plannedRuns using the loadPlannedRunsForPlan method from the Database, setting the return as an array of PlannedRun objects
    2. Sorts the plannedRuns into date order (newest plans at the lowest index)
    */
    func loadPlannedRuns() {
        plannedRuns = Database().loadPlannedRuns(forPlan: self) as! [PlannedRun] //1
        self.plannedRuns = Conversions().sortPlansIntoDateOrder(plannedRuns: self.plannedRuns) //2
    }
}
