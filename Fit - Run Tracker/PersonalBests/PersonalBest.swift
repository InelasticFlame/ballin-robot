//
//  PersonalBest.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 27/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

protocol PersonalBest {
    var personalBestDesc: String { get }
    var displayValue: String { get }
}

class NotYetAchievedPersonalBest: PersonalBest {

    let personalBestDesc: String
    let displayValue: String

    init(personalBestDesc: String) {
        self.personalBestDesc = personalBestDesc
        self.displayValue = "No PB yet, go out and run!"
    }

}

class AchievedPersonalBest: PersonalBest {

    let personalBestDesc: String
    let displayValue: String

    init(personalBestDesc: String, displayValue: String) {
        self.personalBestDesc = personalBestDesc
        self.displayValue = displayValue
    }

}
