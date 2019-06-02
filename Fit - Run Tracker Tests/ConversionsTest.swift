//
//  ConversionsTest.swift
//  Fit - Run Tracker Tests
//
//  Created by William Ray on 24/03/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import XCTest
@testable import Fit___Run_Tracker

class ConversionsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenMetresPerSec_whenConvertingToSecsPerMile_thenConversionIsCorrect() {
        let res = Conversions().metresPerSecondToSecondsPerMile(metresPerSec: 10)

        XCTAssertEqual(res, 160.93, accuracy: 0.01)
    }

    func test_givenMetres_whenConvertingToMiles_thenConversionIsCorrect() {
        let res = Conversions().metresToMiles(meters: 550)

        XCTAssertEqual(res, 0.3417, accuracy: 0.001)
    }

    func test_givenDistanceUnitIsMinMiles_whenGettingPaceForInterface_thenMinMileFormatIsUsed() {
        UserDefaults.standard.set(Constants.DefaultsKeys.Pace.MinMileUnit, forKey: Constants.DefaultsKeys.Pace.UnitKey)

        let res = Conversions().averagePaceForInterface(pace: 630)

        XCTAssertEqual(res, "10:30 min/mile")
    }

    func test_givenDistanceUnitIsKmPerH_whenGettingPaceForInterface_thenKmPerHFormatIsUsed() {
        UserDefaults.standard.set(Constants.DefaultsKeys.Pace.KMPerH, forKey: Constants.DefaultsKeys.Pace.UnitKey)

        let res = Conversions().averagePaceForInterface(pace: 630)

        XCTAssertEqual(res, "9.20 km/h")
    }

    func test_givenDurationLessThanOneHour_whenGettingDurationForInterface_thenMinSecFormatIsUsed() {
        let res = Conversions().runDurationForInterface(duration: 1643)

        XCTAssertEqual(res, "27m 23s")
    }

    func test_givenDurationMoreThanOneHour_whenGettingDurationForInterface_thenMinSecFormatIsUsed() {
        let res = Conversions().runDurationForInterface(duration: 5243)

        XCTAssertEqual(res, "1h 27m 23s")
    }

    func test_givenDistanceUnitIsMiles_whenGettingDistanceForInterface_thenMilesFormatIsUsed() {
        UserDefaults.standard.set(Constants.DefaultsKeys.Distance.MilesUnit, forKey: Constants.DefaultsKeys.Distance.UnitKey)

        let res = Conversions().distanceForInterface(distance: 54.32)

        XCTAssertEqual(res, "54.32 miles")
    }

    func test_givenDistanceUnitIsKm_whenGettingDistanceForInterface_thenKmFormatIsUsed() {
        UserDefaults.standard.set(Constants.DefaultsKeys.Distance.KmUnit, forKey: Constants.DefaultsKeys.Distance.UnitKey)

        let res = Conversions().distanceForInterface(distance: 6.214)

        XCTAssertEqual(res, "10.00 km")
    }

    func test_givenRuns_whenTotalled_thenTotalIsCorrect() {
        let runs = CreateRuns()

        let total = Conversions().totalUpRunMiles(runs: runs)

        XCTAssertEqual(total, 30.47, accuracy: 0.001)
    }

    func test_givenUnsortedRuns_whenSortedByDate_orderIsCorrectAndDescending() {
        let runs = CreateRuns()

        let sortedRuns = Conversions().sortRunsIntoDateOrder(runs: runs)

        XCTAssertEqual(sortedRuns[0].ID, 2)
        XCTAssertEqual(sortedRuns[1].ID, 1)
        XCTAssertEqual(sortedRuns[2].ID, 3)
    }

    func test_givenUnsortedPlans_whenSortedByDate_orderIsCorrectAndAscending() {
        let plannedRuns = CreatePlannedRuns()

        let sortedPlans = Conversions().sortPlansIntoDateOrder(plannedRuns: plannedRuns)

        XCTAssertEqual(sortedPlans[0].ID, 3)
        XCTAssertEqual(sortedPlans[1].ID, 1)
        XCTAssertEqual(sortedPlans[2].ID, 2)
    }

    private func CreateRuns() -> [Run] {
        let date1 = NSDate.init(timeIntervalSinceReferenceDate: 5000)
        let date2 = NSDate.init(timeIntervalSinceReferenceDate: 8000)
        let date3 = NSDate.init(timeIntervalSinceReferenceDate: 3000)

        let run1 = Run(runID: 1, distance: 9.76, dateTime: date1, pace: 0, duration: 0, shoe: nil, runScore: 0, runLocations: [CLLocation](), splits: nil)
        let run2 = Run(runID: 2, distance: 6.5, dateTime: date2, pace: 0, duration: 0, shoe: nil, runScore: 0, runLocations: [CLLocation](), splits: nil)
        let run3 = Run(runID: 3, distance: 14.21, dateTime: date3, pace: 0, duration: 0, shoe: nil, runScore: 0, runLocations: [CLLocation](), splits: nil)

        return [run1, run2, run3]
    }

    private func CreatePlannedRuns() -> [PlannedRun] {
        let date1 = NSDate.init(timeIntervalSinceReferenceDate: 5000)
        let date2 = NSDate.init(timeIntervalSinceReferenceDate: 8000)
        let date3 = NSDate.init(timeIntervalSinceReferenceDate: 3000)

        let plannedRun1 = PlannedRun(ID: 1, date: date1, distance: 5, duration: 5, details: nil)
        let plannedRun2 = PlannedRun(ID: 2, date: date2, distance: 5, duration: 5, details: nil)
        let plannedRun3 = PlannedRun(ID: 3, date: date3, distance: 5, duration: 5, details: nil)

        return [plannedRun1, plannedRun2, plannedRun3]
    }
}
