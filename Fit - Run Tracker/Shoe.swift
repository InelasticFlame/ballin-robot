//
//  Shoe.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Shoe: NSObject {

    // MARK: - Properties

    private(set) var ID: Int //A property that stores the ID of the Shoe; private(set) means that it can only be written from inside this class, but can be read by any class (this is to ensure Database integrity by prevent the unique ID being changed)
    var name: String //A string property that stores the name of the shoe
    var miles: Double //A double property that stores the current miles of the shoe
    var imageName: String? //A string property that stores the imageName (this is used to construct the imagePath)

    // MARK: - Initialisation

    /**
    Called to initialise the class, sets the properties of the Shoe to the passed values.
    
    :param: ID The ID of the Shoe.
    :param: name The name of the Shoe as a string.
    :param: miles The distance ran in the Shoe in miles as a double.
    :param: imageName The name of the Shoe's image store in the local documents directory. This is optional.
    */
    init(ID: Int, name: String, miles: Double, imageName: String?) {
        self.ID = ID
        self.name = name
        self.miles = miles
        self.imageName = imageName
    }

    /**
    This method is called it load the image for the shoe; return a UIImage
    1. IF there is an imageName
        a. Loads the path of the documents directory
        b. Creates the imagePath by appending the imageName and .png to the end of the path
        c. Loads the image from the file at the imagePath
        d. Returns the shoeImage
    2. In the default case returns nil
    
    Uses the following local variables:
        path - A constant string that is the path to the documents directory
        imagePath - A constant string that is the full image path
        shoeImage - A constant UIImage that is the shoe's image retrieved from the documents directory
    
    :returns: The UIImage stored for the Shoe (if there is one). Otherwise returns nil.
    */
    func loadImage() -> UIImage? {
        if let imageName = self.imageName { //1
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String //a
            let imagePath = NSURL(fileURLWithPath: path).appendingPathComponent("\(imageName).png")

            let shoeImage = UIImage(contentsOfFile: imagePath!.absoluteString) //c

            return shoeImage //d
        }

        return nil //2
    }
}
