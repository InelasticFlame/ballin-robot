//
//  MapOverlay.swift
//  CG4 Coursework
//
//  Created by William Ray on 30/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class MapOverlay: UIView {
    /* This class stores the links to the controls for a MapOverlay view */
    
    //MARK: - Storyboard Links
    
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var headerOverlay: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var averagePaceDurationView: UIView!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
}
