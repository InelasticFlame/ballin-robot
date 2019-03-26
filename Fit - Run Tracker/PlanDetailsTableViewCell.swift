//
//  PlanDetailsTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 07/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PlanDetailsTableViewCell: UITableViewCell {
    /* This class stores the links to the controls for a PlanDetailsTableViewCell */

    // MARK: - Storyboard Links

    /* Links to user interface controls */
    @IBOutlet weak var distanceDurationLabel: UILabel! // Middle top label
    @IBOutlet weak var progressImage: UIImageView! //Left image
    @IBOutlet weak var detailLabel: UILabel! //Middle bottom label
    @IBOutlet weak var dateLabel: UILabel! //Left most label
}
