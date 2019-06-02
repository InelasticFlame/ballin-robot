//
//  RunsUITests.swift
//  Fit - Run Tracker UITests
//
//  Created by William Ray on 02/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import XCTest

class RunsUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("UITests")

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenNoRuns_whenRunViewAppears_thenNoRunsWarningIsDisplayed() {
        app.launch()

        app.tabBars.buttons["Runs"].tap()

        let noRunsLabel = app.tables["table--myruns"].staticTexts.firstMatch
        XCTAssertEqual(noRunsLabel.label, "No runs available. Either add a run manually or pull down the table to refresh if a Strava Account is linked.")
    }

    func test_givenStravaAccountLinked_whenRunTableIsPulledDown_thenStravaRunsAreLoaded() {

    }

    func test_givenStoredRuns_whenUserEditsTable_thenTheyCanDeleteRuns() {
        app.launchArguments += ["addRuns"]
        app.launch()

        app.tabBars.buttons["Runs"].tap()

        let myRunsTable = app.tables["table--myruns"]
        let myRunsNavBar = app.navigationBars["My Runs"]

        XCTAssertEqual(myRunsTable.cells.count, 2)

        myRunsNavBar.buttons["Edit"].tap()
        myRunsTable.cells.firstMatch.buttons.firstMatch.tap()
        myRunsTable.buttons["Delete"].tap()

        myRunsNavBar.buttons["Done"].tap()

        XCTAssertTrue(myRunsTable.cells.firstMatch.waitForExistence(timeout: 0.5))
        XCTAssertEqual(myRunsTable.cells.count, 1)
    }

    func test_givenNoRuns_whenUserClicksAddButton_thenTheyCanAddNewRun() {
        app.launch()

        app.tabBars.buttons["Runs"].tap()
        app.navigationBars["My Runs"].buttons["Add"].tap()

        let addRunTable = app.tables["table--addRun"]

        addRunTable.cells["cell--addRun--dateTime"].tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "May 25")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "10")
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "26")
        app.pickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: "AM")

        addRunTable.cells["cell--addRun--distance"].tap()
        app.pickerWheels.element(boundBy: 4).adjust(toPickerWheelValue: "8")
        app.pickerWheels.element(boundBy: 5).adjust(toPickerWheelValue: ".45")
        app.pickerWheels.element(boundBy: 6).adjust(toPickerWheelValue: "mi")

        addRunTable.cells["cell--addRun--duration"].tap()
        app.pickerWheels.element(boundBy: 10).adjust(toPickerWheelValue: "1h")
        app.pickerWheels.element(boundBy: 11).adjust(toPickerWheelValue: "14m")
        app.pickerWheels.element(boundBy: 12).adjust(toPickerWheelValue: "26s")

        app.navigationBars["Add Run"].firstMatch.buttons["Save"].tap()

        let myRunsTable = app.tables["table--myruns"]
        XCTAssertTrue(myRunsTable.waitForExistence(timeout: 0.5))
        XCTAssertEqual(myRunsTable.firstMatch.cells.count, 1)

        let runCell = myRunsTable.firstMatch.cells.element(boundBy: 0)
        XCTAssertTrue(runCell.staticTexts["25/05/2019"].exists)
        XCTAssertTrue(runCell.staticTexts["1h 14m 26s"].exists)
        XCTAssertTrue(runCell.staticTexts["8.45 miles"].exists)
        XCTAssertTrue(runCell.staticTexts["08:48 min/mile"].exists)
    }

    func test_givenRun_whenUserSelectsThatRun_thenRunDetailsAreLoaded() {

    }

}
