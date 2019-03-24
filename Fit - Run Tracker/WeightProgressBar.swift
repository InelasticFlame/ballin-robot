//
//  WeightProgressBar.swift
//  CG4 Coursework
//
//  Created by William Ray on 03/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class WeightProgressBar: UIView {

    //MARK: - Global Variables
    
    private var currentWeight: CGFloat = 0.0 //A global CGFloat that stores the user's current weight to display
    private var goalWeight: CGFloat = 0.0 //A global CGFloat that stores the user's goal weight to display

    //MARK: - Initialisation
    
    /**
    This method is called when the class initialises. It sets the passed properties and the background colour to clear.
    
    :param: currentWeight A CGFloat value that is the user's current weight
    :param: goalWeight A CGFloat value that is the user's goal weight
    :param: frame The frame rectangle for the view, measured in points.
    */
    init(currentWeight: CGFloat, goalWeight: CGFloat, frame: CGRect) {
        self.currentWeight = currentWeight
        self.goalWeight = goalWeight
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    /**
    :param: coder An NSCoder that is used to unarchive the class.
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    //MARK: - Bar Drawing
    
    /**
    This method is called to draw the progress bar.
    1. Declare the local CGFloat barWidth as the width of the rect - 40 (to add padding)
    2. Declare the local CGFloat barHeight as the height of the rect - 20 (to add padding)
    3. Calculate the pixels per kg as half the bar width divided by the goal weight (half the bar width is used as the goal weight is the middle of the bar)
    4. Create the fullBarRectPath as a UIBezierPath from a rect (x = 20 due to the 40 padding, y = 10 due to the 10 padding)
    5. Create the progressBarRectPath as a UIBezierPath from a rect (where the width is the currentWeight * pxPerKg)
    6. Create the fullBar shape layer
    7. Set the layers path, stroke (outline) colour, fill colour and line width
    8. Add the fullBarLayer as a sub layer
    9. Creates the progressBar shape layer
   10. Set the layers path, stroke (outline) colour, fill colour and line width
   11. Add the progressBarLayer as a sub layer
   12. Create the goalMarker layer (the line in the middle of the bar)
   13. Set the goalMarkerLayer path to a CGPath created with a rect (width of 1 px as a single line)
   14. Sets the line colour and the stroke colour
   15. Add the goalMarkerLayer as a sub layer
   16. IF the weight unit is the kg unit
        a. Creates the goal text string as the 'GOALWEIGHT kg', rounding to 2 decimal places
        b. Creates the weight text string as the 'CURRENTWEIGHT kg', rounding to 2 decimal places
   17. ELSE
        c. Creates the goal text string as the 'GOALWEIGHT lb', rounding to 2 decimal places
        d. Creates the weight text string as the 'CURRENTWEIGHT lb', rounding to 2 decimal places
   18. Calculates the size needed for the goalString using the system font of size 12
   19. Create the goalTextLayer CATextLayer
   20. Sets the string (text), font size, font, foreground colour (font colour), frame, position of the text layer
   21. Sets the contentsScale to the mainScreen scale (so if it is retina display the text is clear)
   22. Adds the goalTextLayer as a sublayer
   23. Repeats this process for the weightTextLayer this time using the currentWeight
    
    Uses the following local variables:
        barWidth - A constant CGFloat that stores the width of the bar
        barHeight - A constant CGFloat that stores the height of the bar
        pxPerKg - A constant CGFloat The number of pixels to use per kilogram
        fullBarRectPath - A constant UIBezierPath that stores the full bars path
        progressBarRectPath - A constant UIBezierPath that stores the progress bars path
        fullBarLayer - A constant CAShapeLayer that is the full prgress bar
        progressBarLayer - A constant CAShapeLayer that is the progress bar
        goalMarkerLayer - A constant CAShapeLayer that is the line for the goal
        goalString - A string variable that stores the goal weight as a string
        weightString - A string variable that stores the current weight as a string
        goalStringSize - A constant CGSize that is the size required for the goalString
        goalTextLayer - A CATextLayer that is for the goal text
        weightTextSize - A constant CGSize that is the size required for the weightTextString
        weightTextLayer - A CATextLayer that is for the current weight text
    
    :param: rect The portion of the view’s bounds that needs to be updated.
    */
    override func draw(_ rect: CGRect) {
        let barWidth = rect.size.width - 40 //1
        let barHeight = rect.size.height - 20 //2
        let pxPerKg = (barWidth/2) / goalWeight //3
        let fullBarRectPath = UIBezierPath(rect: CGRect(x: 20, y: 10, width: barWidth, height: barHeight)) //4
        let progressBarRectPath = UIBezierPath(rect: CGRect(x: 20, y: 10, width: CGFloat(Int(currentWeight * pxPerKg)), height: barHeight)) //5
        //Round to an integer value (this ensures no pixel bluring to make it look like half a pixel filled) but the function accepts only CGFloats so cast the int back to a CGFloat
        
        let fullBarLayer = CAShapeLayer() //6
        fullBarLayer.path = fullBarRectPath.cgPath //7
        fullBarLayer.strokeColor = UIColor.black.cgColor
        fullBarLayer.fillColor = UIColor.lightGray.cgColor
        fullBarLayer.lineWidth = 2
        self.layer.addSublayer(fullBarLayer) //8
        
        let progressBarLayer = CAShapeLayer() //9
        progressBarLayer.path = progressBarRectPath.cgPath //10
        progressBarLayer.strokeColor = UIColor.black.cgColor
        progressBarLayer.fillColor = UIColor.red.cgColor
        progressBarLayer.lineWidth = 2
        self.layer.addSublayer(progressBarLayer) //11
        
        let goalMarkerLayer = CAShapeLayer() //12
        goalMarkerLayer.path = CGPath(rect: CGRect(x: rect.size.width/2, y: 10, width: 1, height: barHeight), transform: nil) //13
        goalMarkerLayer.lineWidth = 1 //14
        goalMarkerLayer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(goalMarkerLayer) //15
        
        
        var goalString = ""
        var weightTextString = ""
        
        if UserDefaults.standard.string(forKey: Constants.DefaultsKeys.Weight.UnitKey) == Constants.DefaultsKeys.Weight.KgUnit { //16
            goalString = NSString(format: "Goal: %1.2f kg", Double(goalWeight)) as String //a
            weightTextString = NSString(format: "Weight: %1.2f kg", Double(currentWeight)) as String //b
        } else { //17
            goalString = NSString(format: "Goal: %1.2f lb", Double(goalWeight) * Conversions().kgToPounds) as String //c
            weightTextString = NSString(format: "Weight: %1.2f lb", Double(currentWeight) * Conversions().kgToPounds) as String //d
        }
        
        let goalStringSize = goalString.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 12.0)])) //18
        
        let goalTextLayer = CATextLayer() //19
        goalTextLayer.string = goalString //20
        goalTextLayer.fontSize = 12
        goalTextLayer.font = UIFont.systemFont(ofSize: 12)
        goalTextLayer.foregroundColor = UIColor.black.cgColor
        goalTextLayer.frame = CGRect.init(x: 0, y: 0, width: goalStringSize.width, height: goalStringSize.height)
        goalTextLayer.position.x = (rect.size.width / 2)
        goalTextLayer.position.y = (rect.size.height)
        goalTextLayer.contentsScale = UIScreen.main.scale //21
        self.layer.addSublayer(goalTextLayer) //22
        
        
        let weightTextSize = weightTextString.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 17.0)])) //23
        
        let weightTextLayer = CATextLayer()
        weightTextLayer.string = weightTextString
        weightTextLayer.fontSize = 17
        weightTextLayer.font = UIFont.systemFont(ofSize: 17)
        weightTextLayer.foregroundColor = UIColor.white.cgColor
        weightTextLayer.frame = CGRect.init(x: 40, y: 0, width: weightTextSize.width, height: weightTextSize.height)
        weightTextLayer.position.y = (rect.size.height / 2)
        weightTextLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(weightTextLayer)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
