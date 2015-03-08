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
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
}
