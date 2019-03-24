//
//  RunTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 29/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class RunTableViewCell: UITableViewCell {
    /* This class stores the links to the controls for a RunTableViewCell */
    
    //MARK: - Storyboard Links
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var paceLabel: UILabel! //Bottom left label
    @IBOutlet weak var distanceLabel: UILabel! //Top right label
    @IBOutlet weak var durationLabel: UILabel! //Bottom right label
    @IBOutlet weak var dateLabel: UILabel! //Top left label
    @IBOutlet weak var progressView: UIView! //Background view
}
