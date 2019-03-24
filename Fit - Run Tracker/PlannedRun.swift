//
//  PlannedRun.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class PlannedRun: NSObject {
    
    //MARK: - Properties
    
    private(set) var ID: Int //A property that stores the ID of the Plan; private(set) means that it can only be written from inside this class, but can be read by any class (this is to ensure Database integrity by prevent the unique ID being changed)
    var date: NSDate //An NSDate property that stores the date of the planned run
    var distance: Double //A double property that stores the distance of the planned run (if 0 => planned run is for a duration instead)
    var duration: Int //An integer property that stores the duration of the planned run (if 0 => planned run is for a distance instead)
    var details: String? //A string property that store any details of the planned run
    
    var matchingRun: Run? //An optional Run property that stores the matching run (if there is one)
    var matchRank: Int? //An option Integer property that stores the rank of the match
    //0 = failed
    //1 = kind of
    //2 = success
    //-1 = not happened yet
    

    //MARK: - Initialisation
    
    /**
    Called to initialise the class, sets the properties of the Shoe to the passed values.
    1. Calls the local function checkForCompletedRun to see if the plannedRun has a matching actual run
    
    :param: ID The ID of the Planned Run object.
    :param: date The date of the Planned Run.
    :param: distance The distance to be ran in miles as a double (if the planned run is for a duration this value should be 0).
    :param: duration The duration to be ran in seconds as an integer (if the planned run is for a distance this value should be 0).
    :param: details The details for the Planned Run as a string. This value is optional.
    */
    init(ID: Int, date: NSDate, distance: Double, duration: Int, details: String?) {
        self.ID = ID
        self.date = date
        self.distance = distance
        self.duration = duration
        self.details = details
        
        super.init()
        self.checkForCompletedRun() //1
    }
    
    /**
    This method is called to determine if there is a matching actual run to the planned run, and whether the planned criteria were met.
    1. Loads the matchingRuns as an array of Run objects using the loadRunsWithQuery method form the database class; passing the query "WHERE RunDateTime LIKE 'the planned run date'"
    2. Declares the local integer variable rank
    3. Declares the local optional Run variable matchingRun
    4. FOR each Run object in the array of matchingRuns
        a. IF the current rank is less than 2, there might still be a better matching run
            i. IF the runDistance is greater than or equal to the planned distance
                Y. Set the rank equal to 2
                Z. Set the matchingRun to be the current run
           ii. ELSE IF the runDuration is greater than or equal to the planned duration
                Y. Set the rank equal to 2
                Z. Set the matchingRun to be the current run
        b. IF the current rank is less than 1, there might still be a better matching run
            i. IF the runDistance is greater than or equal to half the planned distance
                Y. Set the rank equal to 1
                Z. Set the matchingRun to be the current run
           ii. ELSE IF the runDuration is greater than or equal to half the planned duration
                Y. Set the rank equal to 1
                Z. Set the matchingRun to be the current run
    5. Declare the local constant now which is the current date
    6. IF the rank is currently 0 and the the planned date is after now
        a. Set the rank to -1
    7. Set the matchingRank property to the rank
    8. Set the matchingRun property to the matchingRun
    
    Uses the following local variables:
        matchingRuns - A immutable array of Run objects that contains all the runs that were ran on the planned run's date
        rank - A integer variable that is the rank of the match (0 = missed, 1 = kind of match, 2 = match, -1 = not happened yet)
        matchingRun - A Run variable that is the run which most closely matches the planned run
        now - A constant NSDate that represents now
    */
    func checkForCompletedRun(){
        let matchingRuns = Database().loadRuns(withQuery: "WHERE RunDateTime LIKE '%\(self.date.shortDateString())%'") as! [Run] //1
        var rank = 0 //2
        var matchingRun: Run? //3
        
        for run: Run in matchingRuns { //4
            if rank < 2 { //a
                if run.distance >= self.distance && self.distance != 0 { //i
                    rank = 2 //Y
                    matchingRun = run //Z
                } else if run.duration >= self.duration && self.duration != 0 { //ii
                    rank = 2 //Y
                    matchingRun = run //Z
                }
            }
            if rank < 1 { //b
                if run.distance >= (self.distance * 0.5) && self.distance != 0 { //i
                    rank = 1 //Y
                    matchingRun = run //Z
                } else if run.duration >= Int(Double(self.duration) * 0.5) && self.duration != 0 { //ii
                    rank = 1 //Y
                    matchingRun = run //Z
                }
            }
        }
        
        let now = NSDate() //5
        
        if rank == 0 && now.compare(self.date as Date) == .orderedAscending { //6
            rank = -1 //a
        }
        
        self.matchRank = rank //7
        self.matchingRun = matchingRun //8
    }
}
