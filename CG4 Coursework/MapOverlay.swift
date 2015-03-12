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
    @IBOutlet weak var headerOverlay: UIView! //Top bar
    @IBOutlet weak var dateLabel: UILabel! //Top right label
    @IBOutlet weak var timeLabel: UILabel! //Top left label
    @IBOutlet weak var scoreLabel: UILabel! //Bottom left red label (on the map)
    @IBOutlet weak var distanceLabel: UILabel! //Bottom right red label (on the map)
    
    @IBOutlet weak var averagePaceDurationView: UIView! //Bottom bar
    @IBOutlet weak var averagePaceLabel: UILabel! //Bottom left label
    @IBOutlet weak var durationLabel: UILabel! //Bottom right label
    
}
