//
//  Shoe.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Shoe: NSObject {
    
    var ID: Int
    var name: String
    var miles: Double
    var imagePath: String?
    
    init(ID: Int, name: String, miles: Double, imagePath: String?) {
        self.ID = ID
        self.name = name
        self.miles = miles
        self.imagePath = imagePath
    }
    
    func loadImage() -> UIImage {
        return UIImage(named: self.imagePath!)!
    }
}
