//
//  Shoe.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Shoe: NSObject {
    
    private(set) var ID: Int
    var name: String
    var miles: Double
    var imageName: String
    
    init(ID: Int, name: String, miles: Double, imagePath: String?) {
        self.ID = ID
        self.name = name
        self.miles = miles
        
        if let _imagePath = imagePath {
            self.imageName = _imagePath
        } else {
            self.imageName = ""
        }
    }
    
    func loadImage() -> UIImage? {
        return UIImage(named: self.imageName)
    }
}
