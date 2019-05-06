//
//  PersonalBestCellFactory.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 27/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

class PersonalBestCellFactory: CellFactory {
    typealias CellContents = PersonalBest
    typealias CellType = PersonalBestTableViewCell

    let achievedImage = UIImage(named: "trophyImage90px")
    let notAchievedImage = UIImage(named: "noTrophyImage90px")

    func createCell(cell: PersonalBestTableViewCell, item: PersonalBest) {
        cell.personalBestDescLabel.text = item.personalBestDesc
        cell.personalBestValueLabel.text = item.displayValue

        if type(of: item) == NotYetAchievedPersonalBest.self {
            cell.personalBestImage.image = notAchievedImage
        } else {
            cell.personalBestImage.image = achievedImage
        }
    }

}
