//
//  RunCellFactory.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 27/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

class RunCellFactory: CellFactory {
    typealias CellContents = Run
    typealias CellType = RunTableViewCell

    func createCell(cell: RunTableViewCell, item run: Run) {
        cell.distanceLabel.text = Conversions().distanceForInterface(distance: run.distance)
        cell.dateLabel.text = run.dateTime.toShortDateString
        cell.paceLabel.text = Conversions().averagePaceForInterface(pace: run.pace)
        cell.durationLabel.text = Conversions().runDurationForInterface(duration: run.duration)

        cell.progressView.backgroundColor = run.scoreColour()
        cell.progressView.alpha = 0.4
    }

}
