//
//  StravaClient.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 02/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

protocol StravaClient {

    var isAuthorised: Bool { get }

    func authorise()
    func loadRuns() -> [Run]

}

class DevStravaClient: StravaClient {
    var isAuthorised: Bool = true

    func authorise() {
        // no-op
    }

    func loadRuns() -> [Run] {
        return [Run(runID: 1, distance: 15.4, dateTime: Date(), pace: 540, duration: 8316, shoe: nil, runScore: 0.0, runLocations: nil, splits: nil)]
    }

}
