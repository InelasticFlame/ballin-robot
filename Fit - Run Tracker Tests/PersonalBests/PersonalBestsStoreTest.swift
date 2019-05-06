//
//  PersonalBestsStoreTest.swift
//  Fit - Run Tracker Tests
//
//  Created by William Ray on 06/05/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import XCTest
@testable import Fit___Run_Tracker

class PersonalBestsStoreTest: XCTestCase {

    func test_givenNoValueExistForPb_whenPbsAreLoaded_thenNotAchievedPbIsLoaded() {
        UserDefaults.standard.removeObject(forKey: Constants.DefaultsKeys.PersonalBests.FastestMileKey)

        let store = PersonalBestStore()
        store.refresh()

        let pb = store.get(atIndex: PersonalBests.fastestMile.rawValue)

        XCTAssertTrue(type(of: pb) == NotYetAchievedPersonalBest.self)
    }

    func test_givenValueExistForPb_whenPbsAreLoaded_thenAchievedPbIsLoaded() {
        UserDefaults.standard.set(10.0, forKey: Constants.DefaultsKeys.PersonalBests.LongestDistanceKey)

        let store = PersonalBestStore()
        store.refresh()

        let pb = store.get(atIndex: PersonalBests.longestDistance.rawValue)

        XCTAssertEqual(pb.displayValue, "10.00 miles")
        XCTAssertEqual(pb.personalBestDesc, "Longest Distance")
    }

    func test_givenSomePbs_whenPbsAreLoaded_thenAllPbsAreLoaded() {
        let store = PersonalBestStore()
        store.refresh()

        XCTAssertEqual(store.count, 4)
    }

}
