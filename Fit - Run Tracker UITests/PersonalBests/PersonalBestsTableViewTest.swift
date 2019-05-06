//
//  PersonalBestsTableViewTest.swift
//  Fit - Run Tracker UITests
//
//  Created by William Ray on 06/05/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import XCTest

class PersonalBestsTableViewTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func test_givenSomePbs_whenPbsViewIsShown_thenPbsAreDisplayed() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        // TODO: more about UI testing

        let app = XCUIApplication()
        app.tabBars.buttons["More"].tap()
        app.tables["table--more"].cells["cell--personalBests"].tap()
        let personalBestsView = app.tables["table--personalBestsView"]

        XCTAssertEqual(personalBestsView.cells.count, 4)
    }

}
