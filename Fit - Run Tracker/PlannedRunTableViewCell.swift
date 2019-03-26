//
//  PlannedRunTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PlannedRunTableViewCell: UITableViewCell {

    /* This class stores the links to the controls for a PlanDetailsTableViewCell */

    // MARK: - Storyboard Links

    /* Links to user interface controls */
    @IBOutlet weak var dateLabel: UILabel! //Left most label
    @IBOutlet weak var distanceDurationLabel: UILabel! //Middle top label
    @IBOutlet weak var detailsLabel: UILabel! //Middle bottom label

}
