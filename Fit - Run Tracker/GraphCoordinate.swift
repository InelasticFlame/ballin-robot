//
//  GraphCoordinate.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class GraphCoordinate: NSObject {
    
    //MARK: - Properties
    
    var x: String //The string to write on the x-axis
    var y: CGFloat //The y value
    
    //MARK: - Initialisation
    
    /**
    Called to initialise a GraphCoordinate object, sets the properties to the passed values.
    
    :param: x The string to display on the X axis.
    :param: y The value of the Y object.
    */
    init(x: String, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
