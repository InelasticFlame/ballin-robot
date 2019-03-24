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
    1. IF the progress is more than 1
        a. Set the progress to 1 (cannot have more than 100% progress)
    2. ELSE set the progress to the progress
    
    :param: A CGRect of the frame rectangle for the view, measured in points.
    :param: progress A CGFloat value that is the amount of progress as a decimal.
    */
    init(progress: CGFloat, frame: CGRect) {
        if progress > 1 { //1
            self.progress = 1 //a
        } else { //2
            self.progress = progress
        }
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    /**
    This method initialises the class using an unarchiver.
    
    :param: coder An NSCoder that is used to unarchive the class.
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
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
    
    Uses the following local variables:
        arcRadius - A constant CGFloat that stores the radius of the arc
        arcCentrePoint - A constant CGPoint that stores the centre point of the arc
        fullArc - A constant UIBezierPath that stores the path for the full arc (the grey background arc)
        progressAngle - A constant CGFloat that stores the angle to create the progress arc to
        progressArc - A constant UIBezierPath that stores the path for the progress arc (the red foreground arc)
        fullArcLayer - A constant CAShapeLayer for the full arc
        progressArcLayer - A constant CAShapeLayer for the progress arc
        progressTextString - A constant NSString that stores the progress as a string
        progressTextSize - A constant CGSize that stores the size required for the progress string
        progressTextLayer - A constant CATextLayer for the text to add to the progress bar
    
    :param: The portion of the view’s bounds that needs to be updated.
    */
    override func draw(_ rect: CGRect) {
        let arcRadius = (rect.size.height*11) / 16 //1
        let arcCentrePoint = CGPoint(x: (rect.size.width/2), y: (rect.size.height)  - (arcRadius / 8)) //2
        let fullArc = UIBezierPath(arcCenter: arcCentrePoint, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true) //3
        let progressAngle = CGFloat(startAngle) * CGFloat(progress) + startAngle //4
        let progressArc = UIBezierPath(arcCenter: arcCentrePoint, radius: arcRadius, startAngle: startAngle, endAngle: progressAngle, clockwise: true) //5
        
        let fullArcLayer = CAShapeLayer() //6
        fullArcLayer.path = fullArc.cgPath //7
        fullArcLayer.fillColor = UIColor.clear.cgColor
        fullArcLayer.strokeColor = UIColor.lightGray.cgColor
        fullArcLayer.lineWidth = 27
        self.layer.addSublayer(fullArcLayer) //8
        
        let progressArcLayer = CAShapeLayer() //9
        progressArcLayer.path = progressArc.cgPath //10
        progressArcLayer.fillColor = UIColor.clear.cgColor
        progressArcLayer.strokeColor = UIColor.red.cgColor
        progressArcLayer.lineWidth = 27
        self.layer.addSublayer(progressArcLayer) //11
        
        let progressTextString = NSString(format: "%1.2f%%", Double(progress * 100)) //12
        let progressTextSize = progressTextString.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 20.0)])) //13
        
        let progressTextLayer = CATextLayer() //14
        progressTextLayer.string = progressTextString //15
        progressTextLayer.fontSize = 20
        progressTextLayer.font = UIFont.systemFont(ofSize: 20)
        progressTextLayer.foregroundColor = UIColor.black.cgColor
        progressTextLayer.frame = CGRect.init(x: 0, y: 0, width: progressTextSize.width, height: progressTextSize.height);
        progressTextLayer.position.y = arcRadius
        progressTextLayer.position.x = arcCentrePoint.x
        progressTextLayer.contentsScale = UIScreen.main.scale //16
        self.layer.addSublayer(progressTextLayer) //17
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
