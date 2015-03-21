//
//  ProgressBar.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    
    //MARK: - Global Variables
    
    private let startAngle = CGFloat(M_PI) //A global constant GFloat that stores the start angle for the bar (PI)
    private let endAngle = CGFloat(M_PI * 2) //A global constant CGFloat that stores the end angle for the bar (2PI)
    
    private var progress: CGFloat = 0.0 //A global variable CGFloat that stores the progress amount
    
    //MARK: - Initialisation
    
    /**
    This method is called when the class initialises. It sets the passed properties and the background colour to clear.
    */
    init(progress: CGFloat, frame: CGRect) {
        self.progress = progress
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Bar Drawing
    
    /**
    This method is called to draw the progress bar.
    1. Calculates the radius to use for the arc
    2. Creates the arc centre point
    3. Creates the full arc as a UIBezierPath with an arc
    4. Creates the progress angle, this is the (start angle * the progress) plus the start angle
        (the total maximum is PI (startAngle) so the arc length is startAngle * progress, the startAngle is then added so it starts in the correct place)
    5. Creates the progress arc as UIBezierPath with an arc
    6. Create the fullArc CAShapeLayer
    7. Sets its path, fill colour (clear because only the path wants filling), stroke (outline) colour and line width
    8. Adds the fullArcLayer as a sublayer
    9. Create the progressArc CAShapeLayer
   10. Sets its path, fill colour (clear because only the path wants filling), stroke (outline) colour and line width
   11. Adds the progressArcLayer as a sublayer
   12. Creates the progress text string as the PROGRESS%, rounding to 2 decimal places
   13. Calculates the size needed for the progressTextString using the system font of size 20
   14. Create the progressText CATextLayer
   15. Sets the string (text), font size, font, foreground colour (font colour), frame, position of the text layer
   16. Sets the contentsScale to the mainScreen scale (so if it is retina display the text is clear)
   17. Adds the progressTextLayer as a sublayer
    */
    override func drawRect(rect: CGRect) {
        let arcRadius = (rect.size.height*11) / 16 //1
        let arcCentrePoint = CGPoint(x: (rect.size.width/2), y: (rect.size.height)  - (arcRadius / 8)) //2
        let fullArc = UIBezierPath(arcCenter: arcCentrePoint, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true) //3
        let progressAngle = CGFloat(startAngle) * CGFloat(progress) + startAngle //4
        let progressArc = UIBezierPath(arcCenter: arcCentrePoint, radius: arcRadius, startAngle: startAngle, endAngle: progressAngle, clockwise: true) //5
        
        let fullArcLayer = CAShapeLayer() //6
        fullArcLayer.path = fullArc.CGPath //7
        fullArcLayer.fillColor = UIColor.clearColor().CGColor
        fullArcLayer.strokeColor = UIColor.lightGrayColor().CGColor
        fullArcLayer.lineWidth = 27
        self.layer.addSublayer(fullArcLayer) //8
        
        let progressArcLayer = CAShapeLayer() //9
        progressArcLayer.path = progressArc.CGPath //10
        progressArcLayer.fillColor = UIColor.clearColor().CGColor
        progressArcLayer.strokeColor = UIColor.redColor().CGColor
        progressArcLayer.lineWidth = 27
        self.layer.addSublayer(progressArcLayer) //11
        
        let progressTextString = NSString(format: "%1.2f%%", Double(progress * 100)) //12
        let progressTextSize = progressTextString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20.0)]) //13
        
        let progressTextLayer = CATextLayer() //14
        progressTextLayer.string = progressTextString //15
        progressTextLayer.fontSize = 20
        progressTextLayer.font = UIFont.systemFontOfSize(20)
        progressTextLayer.foregroundColor = UIColor.blackColor().CGColor
        progressTextLayer.frame = CGRectMake(0, 0, progressTextSize.width, progressTextSize.height);
        progressTextLayer.position.y = arcRadius
        progressTextLayer.position.x = arcCentrePoint.x
        progressTextLayer.contentsScale = UIScreen.mainScreen().scale //16
        self.layer.addSublayer(progressTextLayer) //17
    }
}
