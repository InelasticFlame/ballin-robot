//
//  RunStore.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 06/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

class RunStore: Store {
    typealias StoreType = Run

    var count: Int { return runs.count }
    var runs: [Run] = []

    init() {
        self.runs = Database().loadRuns(withQuery: "") as! [Run]
    }

    func get(atIndex index: Int) -> Run {
        return runs[index]
    }

    func refresh() {
        self.runs = Database().loadRuns(withQuery: "") as! [Run]
    }

}

class RunCellFactory: CellFactory {
    typealias CellContents = Run
    typealias CellType = RunTableViewCell

    func createCell(cell: RunTableViewCell, item run: Run) {
        cell.distanceLabel.text = Conversions().distanceForInterface(distance: run.distance)
        cell.dateLabel.text = run.dateTime.shortDateString()
        cell.paceLabel.text = Conversions().averagePaceForInterface(pace: run.pace)
        cell.durationLabel.text = Conversions().runDurationForInterface(duration: run.duration)

        cell.progressView.backgroundColor = run.scoreColour()
        cell.progressView.alpha = 0.4
    }
}
