//
//  DistanceTest.swift
//  Fit - Run Tracker Tests
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import XCTest
@testable import Fit___Run_Tracker

class DistanceTest: XCTestCase {

    private let epsilon = 0.001

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Miles

    func test_givenDistanceInMiles_whenConvertingToKm_thenConversionIsCorrect() {
        let distance = 15.miles

        XCTAssertEqual(distance.toKilometres().rawValue, 24.14, accuracy: epsilon)
    }

    func test_givenDistanceInMiles_whenConvertingToMilesString_thenStringIsCorrect() {
        let distance = 4.9.miles

        XCTAssertEqual(distance.toString(Miles.unit), "4.90 miles")
    }

    func test_givenDistanceInMiles_whenConvertingToKilometresString_thenDistanceIsConvertedAndStringIsCorrect() {
        let distance = 4.9.miles

        XCTAssertEqual(distance.toString(Kilometres.unit), "7.89 km")
    }

    func test_milesIntExtensionWork() {
        let d1 = 26.miles

        XCTAssertEqual(d1.rawValue, 26, accuracy: epsilon)
    }

    func test_milesDoubleExtensionWork() {
        let d1 = 26.2.miles

        XCTAssertEqual(d1.rawValue, 26.2, accuracy: epsilon)
    }

    // MARK: - Kilometres

    func test_givenDistanceInKilometres_whenConvertingToMiles_thenConversionIsCorrect() {
        let distance = 56.2.kilometres

        XCTAssertEqual(distance.toMiles().rawValue, 34.921, accuracy: epsilon)
    }

    func test_givenDistanceInKilometres_whenConvertingToKilometresString_thenStringIsCorrect() {
        let distance = 14.1.kilometres

        XCTAssertEqual(distance.toString(Kilometres.unit), "14.10 km")
    }

    func test_givenDistanceInKilometres_whenConvertingToMilesString_thenDistanceIsConvertedAndStringIsCorrect() {
        let distance = 14.1.kilometres

        XCTAssertEqual(distance.toString(Miles.unit), "8.76 miles")
    }

    func test_kilometresIntExtensionsWork() {
        let d1 = 100.metres
        let d2 = 56.kilometres

        XCTAssertEqual(d1.rawValue, 0.1, accuracy: epsilon)
        XCTAssertEqual(d2.rawValue, 56.0, accuracy: epsilon)
    }

    func test_kilometresDoubleExtensionsWork() {
        let d1 = 50.5.metres
        let d2 = 20.1.kilometres

        XCTAssertEqual(d1.rawValue, 0.0505, accuracy: epsilon)
        XCTAssertEqual(d2.rawValue, 20.1, accuracy: epsilon)
    }

}
