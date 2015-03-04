//
//  ProgressBar.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    private let startAngle = CGFloat(M_PI)
    private let endAngle = CGFloat(M_PI * 2)
    private var progress: CGFloat = 0.0
    
    init(progress: CGFloat, frame: CGRect) {
        self.progress = progress
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let arcRadius = (rect.size.height*11) / 16
        let arcCentrePoint = CGPoint(x: (rect.size.width/2), y: (rect.size.height)  - (arcRadius / 8))
        let fullArc = UIBezierPath(arcCenter: arcCentrePoint, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let progressAngle = CGFloat(startAngle) * CGFloat(progress) + startAngle
        let progressArc = UIBezierPath(arcCenter: arcCentrePoint, radius: arcRadius, startAngle: startAngle, endAngle: progressAngle, clockwise: true)
        
        let fullArcLayer = CAShapeLayer()
        fullArcLayer.path = fullArc.CGPath
        fullArcLayer.fillColor = UIColor.clearColor().CGColor
        fullArcLayer.strokeColor = UIColor.lightGrayColor().CGColor
        fullArcLayer.lineWidth = 27
        self.layer.addSublayer(fullArcLayer)
        
        let progressArcLayer = CAShapeLayer()
        progressArcLayer.path = progressArc.CGPath
        progressArcLayer.fillColor = UIColor.clearColor().CGColor
        progressArcLayer.strokeColor = UIColor.redColor().CGColor
        progressArcLayer.lineWidth = 27
        self.layer.addSublayer(progressArcLayer)
        
        let progressTextString = NSString(format: "%1.2f%%", Double(progress * 100))
        let progressTextSize = progressTextString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20.0)])
        
        let progressTextLayer = CATextLayer()
        progressTextLayer.string = progressTextString
        progressTextLayer.fontSize = 20
        progressTextLayer.font = UIFont.systemFontOfSize(20)
        progressTextLayer.foregroundColor = UIColor.blackColor().CGColor
        progressTextLayer.frame = CGRectMake(0, 0, progressTextSize.width, progressTextSize.height);
        progressTextLayer.position.y = arcRadius
        progressTextLayer.position.x = arcCentrePoint.x
        progressTextLayer.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(progressTextLayer)
    }
}
