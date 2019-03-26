//
//  Conversions.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Conversions: NSObject {

    // MARK: Conversion Constants

    let kmToMiles = 0.621371192
    let milesToKm = 1.609344
    let poundsToKg = 0.453592
    let kgToPounds = 2.20462

    // MARK: Conversion Methods

    func metresPerSecondToSecondsPerMile(metresPerSec: Double) -> Double {
        let metresPerHour = metresPerSec * 3600
        let kmPerHour: Double = metresPerHour / 1000
        let milesPerHour: Double = kmPerHour * kmToMiles
        let secPerMile = 3600 / milesPerHour

        return secPerMile
    }

    func metresToMiles(meters: Double) -> (Double) {
        let miles = (meters/1000)*kmToMiles

        return miles
    }

    // MARK: Stringify Methods

    func averagePaceForInterface(pace: Int) -> String {
        var paceString = ""
        let paceUnit = UserDefaults.standard.string(forKey: Constants.DefaultsKeys.Pace.UnitKey)

        if paceUnit == Constants.DefaultsKeys.Pace.MinMileUnit || paceUnit == "" {
            let minutes = pace/60
            let seconds = pace % 60
            paceString = (NSString(format: "%02i:%02i", minutes, seconds) as String) + " min/mile"
        } else if paceUnit == Constants.DefaultsKeys.Pace.KMPerH {
            let mph = 3600.0/Double(pace)
            let kmh = Double(mph) * milesToKm
            paceString = (NSString(format: "%1.2f", kmh) as String) + " km/h"
        }

        return paceString
    }

    func runDurationForInterface(duration: Int) -> String {
        var duratonString = ""
        let hours = duration / 3600
        let minutesInSeconds = duration % 3600
        let minutes = minutesInSeconds / 60
        let seconds = duration % 60

        if hours > 0 {
            duratonString = NSString(format: "%ih %02im %02is", hours, minutes, seconds) as String
        } else {
            duratonString = NSString(format: "%02im %02is", minutes, seconds) as String
        }

        return duratonString
    }

    func distanceForInterface(distance: Double) -> String {
        var distanceString = ""
        let distanceUnit = UserDefaults.standard.string(forKey: Constants.DefaultsKeys.Distance.UnitKey)

        if distanceUnit == Constants.DefaultsKeys.Distance.MilesUnit || distanceUnit == "" {
            distanceString = (NSString(format: "%1.2f", distance) as String) + " miles"
        } else if distanceUnit == Constants.DefaultsKeys.Distance.KmUnit {
            let kilometres = distance * milesToKm
            distanceString = (NSString(format: "%1.2f", kilometres) as String) + " km"
        }

        return distanceString
    }

    // MARK: Array Sorting

    func totalUpRunMiles(runs: Array<Run>) -> Double {
        var total = 0.0
        for run: Run in runs {
            total += run.distance
        }

        return total
    }

    func sortRunsIntoDateOrder(runs array: Array<Run>) -> Array<Run> {

        var runs = array //Create a mutable version of the array

        runs.sort(by: {$0.dateTime.timeIntervalSinceNow > $1.dateTime.timeIntervalSinceNow})

        return runs
    }

    func sortPlansIntoDateOrder(plannedRuns array: Array<PlannedRun>) -> Array<PlannedRun> {
        var plannedRuns = array //Create a mutable copy of the array

        plannedRuns.sort(by: {$0.date.timeIntervalSinceNow < $1.date.timeIntervalSinceNow})

        return plannedRuns
    }
}
