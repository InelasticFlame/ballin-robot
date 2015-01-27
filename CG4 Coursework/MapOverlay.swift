//
//  MapOverlay.swift
//  CG4 Coursework
//
//  Created by William Ray on 30/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class MapOverlay: UIView {

    //This class stores the properties for the map's overlay.
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var headerOverlay: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
}
