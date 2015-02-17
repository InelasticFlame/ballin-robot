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
    
    //MARK: - Storyboard Links
    
    /* Links to user interface controls */
    @IBOutlet weak var distanceDurationLabel: UILabel!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
