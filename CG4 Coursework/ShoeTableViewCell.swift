//
//  ShoeTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class ShoeTableViewCell: UITableViewCell {
    /* This class stores the links to the controls for a ShoeTableViewCell */
    
    //MARK: - Storyboard Links
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var shoeNameLabel: UILabel!
    @IBOutlet weak var shoeMilesLabel: UILabel!
    @IBOutlet weak var shoeImageView: UIImageView!
}
