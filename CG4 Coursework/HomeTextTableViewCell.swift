//
//  HomeTextTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class HomeTextTableViewCell: UITableViewCell {
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Conversions().addBorderToView(self.headerView)
        Conversions().addBorderToView(self.mainView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
