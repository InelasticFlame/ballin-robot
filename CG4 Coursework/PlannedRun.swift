//
//  PlannedRun.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class PlannedRun: NSObject {
    
    var ID: Int
    var date: NSDate
    var distance: Double
    var duration: Int
    var details: String?
    
    init(ID: Int, date: NSDate, distance: Double, duration: Int, details: String?) {
        self.ID = ID
        self.date = date
        self.distance = distance
        self.duration = duration
        self.details = details
    }
    
    func checkForCompletedRun() -> Int {
        let runs = Database().loadRunsWithQuery("WHERE RunDate = '\(self.date.shortDateString())'") as Array<Run>
        var match = 0
        
        for run: Run in runs {
            if match < 2 {
                if run.distance >= self.distance {
                    match = 2
                } else if run.duration >= self.duration {
                    match = 2
                }
            } else if match < 1 {
                if run.distance >= self.distance {
                    match = 1
                } else if run.duration >= self.duration {
                    match = 1
                }
            }
        }
        
        return match
    }
}
