//
//  RunTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 29/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class RunTableViewCell: UITableViewCell {

    @IBOutlet var paceLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var progressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
