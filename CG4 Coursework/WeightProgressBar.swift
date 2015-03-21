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
    
    private var currentWeight: CGFloat = 0.0
    private var goalWeight: CGFloat = 0.0

    //MARK: - Initialisation
    
    /**
    This method is called when the class initialises. It sets the passed properties and the background colour to clear.
    */
    init(currentWeight: CGFloat, goalWeight: CGFloat, frame: CGRect) {
        self.currentWeight = currentWeight
        self.goalWeight = goalWeight
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    */
    override func drawRect(rect: CGRect) {
        let barWidth = rect.size.width - 40 //1
        let barHeight = rect.size.height - 20 //2
        let pxPerKg = (barWidth/2) / goalWeight //3
        let fullBarRectPath = UIBezierPath(rect: CGRect(x: 20, y: 10, width: barWidth, height: barHeight)) //4
        let progressBarRectPath = UIBezierPath(rect: CGRect(x: 20, y: 10, width: CGFloat(Int(currentWeight * pxPerKg)), height: barHeight)) //5
        //Round to an integer value (this ensures no pixel bluring to make it look like half a pixel filled) but the function accepts only CGFloats so cast the int back to a CGFloat
        
        let fullBarLayer = CAShapeLayer() //6
        fullBarLayer.path = fullBarRectPath.CGPath //7
        fullBarLayer.strokeColor = UIColor.blackColor().CGColor
        fullBarLayer.fillColor = UIColor.lightGrayColor().CGColor
        fullBarLayer.lineWidth = 2
        self.layer.addSublayer(fullBarLayer) //8
        
        let progressBarLayer = CAShapeLayer() //9
        progressBarLayer.path = progressBarRectPath.CGPath //10
        progressBarLayer.strokeColor = UIColor.blackColor().CGColor
        progressBarLayer.fillColor = UIColor.redColor().CGColor
        progressBarLayer.lineWidth = 2
        self.layer.addSublayer(progressBarLayer) //11
        
        let goalMarkerLayer = CAShapeLayer() //12
        goalMarkerLayer.path = CGPathCreateWithRect(CGRect(x: rect.size.width/2, y: 10, width: 1, height: barHeight), nil) //13
        goalMarkerLayer.lineWidth = 1 //14
        goalMarkerLayer.strokeColor = UIColor.blackColor().CGColor
        self.layer.addSublayer(goalMarkerLayer) //15
        
        
        var goalString = ""
        var weightTextString = ""
        
        if NSUserDefaults.standardUserDefaults().stringForKey(Constants.DefaultsKeys.Weight.UnitKey) == Constants.DefaultsKeys.Weight.KgUnit { //16
            goalString = NSString(format: "Goal: %1.2f kg", Double(goalWeight)) //a
            weightTextString = NSString(format: "Weight: %1.2f kg", Double(currentWeight)) //b
        } else { //17
            goalString = NSString(format: "Goal: %1.2f lb", Double(goalWeight) * Conversions().kgToPounds) //c
            weightTextString = NSString(format: "Weight: %1.2f lb", Double(currentWeight) * Conversions().kgToPounds) //d
        }
        
        let goalStringSize = goalString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0)]) //18
        
        let goalTextLayer = CATextLayer() //19
        goalTextLayer.string = goalString //20
        goalTextLayer.fontSize = 12
        goalTextLayer.font = UIFont.systemFontOfSize(12)
        goalTextLayer.foregroundColor = UIColor.blackColor().CGColor
        goalTextLayer.frame = CGRectMake(0, 0, goalStringSize.width, goalStringSize.height);
        goalTextLayer.position.x = (rect.size.width / 2)
        goalTextLayer.position.y = (rect.size.height)
        goalTextLayer.contentsScale = UIScreen.mainScreen().scale //21
        self.layer.addSublayer(goalTextLayer) //22
        
        
        let weightTextSize = weightTextString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)]) //23
        
        let weightTextLayer = CATextLayer()
        weightTextLayer.string = weightTextString
        weightTextLayer.fontSize = 17
        weightTextLayer.font = UIFont.systemFontOfSize(17)
        weightTextLayer.foregroundColor = UIColor.whiteColor().CGColor
        weightTextLayer.frame = CGRectMake(40, 0, weightTextSize.width, weightTextSize.height);
        weightTextLayer.position.y = (rect.size.height / 2)
        weightTextLayer.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(weightTextLayer)
    }
}
