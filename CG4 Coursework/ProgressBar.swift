//
//  ProgressBar.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    let startAngle = CGFloat(M_PI)
    let endAngle = CGFloat(M_PI * 2)
    let progress: Double
    
    init(progress: Double, frame: CGRect) {
        self.progress = progress
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        let arcRadius = (rect.size.width*3) / 8
        let arcCentrePoint = CGPoint(x: rect.size.width/2, y: (rect.size.height)/2)
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
    }
}
