//
//  RunScore.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import Foundation

struct RunScore {

    let value: Double
    let colour: UIColor

    init(_ score: Double) {
        self.value = score

        if self.value < 400 {
            self.colour = UIColor.red
        } else if self.value < 700 {
            self.colour = UIColor.orange
        } else {
            self.colour = UIColor.green
        }
    }
}

class RunScorer {

    static func score(run: Run) -> RunScore {
        let pointsFromPacePower = 1000.0/Float(run.pace)
        let pointsFromAveragePace = Double(pow(2.4, pointsFromPacePower) * 120)

        let pointsFromDistancePower = run.distance.rawValue / 10.0
        let pointsFromDistance = Double(pow(2.4, pointsFromDistancePower)) * 120

        let totalPoints = (pointsFromDistance + pointsFromAveragePace)

        if totalPoints > 1000 {
            return RunScore(1000)
        } else {
            return RunScore(totalPoints)
        }
    }

}
