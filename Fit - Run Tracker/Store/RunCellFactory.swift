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
        // TODO: should check what the display unit is
        cell.distanceLabel.text = run.distance.toString(Miles.unit)
        cell.dateLabel.text = run.dateTime.toShortDateString
        cell.paceLabel.text = Conversions().averagePaceForInterface(pace: run.pace)
        cell.durationLabel.text = Conversions().runDurationForInterface(duration: run.duration)

        cell.progressView.backgroundColor = run.score.colour
        cell.progressView.alpha = 0.4
    }

}
