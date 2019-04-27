//
//  PersonalBestStore.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 27/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

enum PersonalBests: Int {
    case longestDistance = 0
    case longestDuration = 1
    case fastestMile = 2
    case bestAvgPace = 3
}

class PersonalBestStore: Store {
    typealias StoreType = PersonalBest

    var personalBests: [PersonalBest] = []
    var count: Int { return personalBests.count }

    func get(atIndex index: Int) -> PersonalBest {
        return personalBests[index]
    }

    func remove(atIndex index: Int) {
        personalBests.remove(at: index)
    }

    func refresh() {
        // TODO: sometimes code gets worse to get better.
        // ^ that's what I'm telling myself

        personalBests = []

        let userDefaults = UserDefaults.standard
        let longestDistance = userDefaults.double(forKey: Constants.DefaultsKeys.PersonalBests.LongestDistanceKey)
        let longestDuration = userDefaults.integer(forKey: Constants.DefaultsKeys.PersonalBests.LongestDurationKey)
        let fastestMile = userDefaults.integer(forKey: Constants.DefaultsKeys.PersonalBests.FastestMileKey)
        let bestAvgPace = userDefaults.integer(forKey: Constants.DefaultsKeys.PersonalBests.BestAvgPaceKey)

        if longestDistance > 0 {
            let longestDistancePb = AchievedPersonalBest(personalBestDesc: "Longest Distance", displayValue: Conversions().distanceForInterface(distance: longestDistance))

            personalBests.insert(longestDistancePb, at: PersonalBests.longestDistance.rawValue)
        } else {
            personalBests.insert(NotYetAchievedPersonalBest(personalBestDesc: "Longest Distance"), at: PersonalBests.longestDistance.rawValue)
        }

        if longestDuration > 0 {
            let longestDurationPb = AchievedPersonalBest(personalBestDesc: "Longest Duration", displayValue: Conversions().runDurationForInterface(duration: longestDuration))

            personalBests.insert(longestDurationPb, at: PersonalBests.longestDuration.rawValue)
        } else {
            personalBests.insert(NotYetAchievedPersonalBest(personalBestDesc: "Longest Duration"), at: PersonalBests.longestDuration.rawValue)
        }

        if fastestMile > 0 {
            let fastestMilePb = AchievedPersonalBest(personalBestDesc: "Fastest Mile", displayValue: Conversions().averagePaceForInterface(pace: fastestMile))

            personalBests.insert(fastestMilePb, at: PersonalBests.fastestMile.rawValue)
        } else {
            personalBests.insert(NotYetAchievedPersonalBest(personalBestDesc: "Fastest Mile"), at: PersonalBests.fastestMile.rawValue)
        }

        if bestAvgPace > 0 {
            let bestAvgPacePb = AchievedPersonalBest(personalBestDesc: "Best Average Pace", displayValue: Conversions().averagePaceForInterface(pace: bestAvgPace))

            personalBests.insert(bestAvgPacePb, at: PersonalBests.bestAvgPace.rawValue)
        } else {
            personalBests.insert(NotYetAchievedPersonalBest(personalBestDesc: "Best Average Pace"), at: PersonalBests.bestAvgPace.rawValue)
        }
    }

}
