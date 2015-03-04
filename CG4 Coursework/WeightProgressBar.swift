//
//  WeightProgressBar.swift
//  CG4 Coursework
//
//  Created by William Ray on 03/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class WeightProgressBar: UIView {

    private var currentWeight: CGFloat = 0.0
    private var goalWeight: CGFloat = 0.0

    init(currentWeight: CGFloat, goalWeight: CGFloat, frame: CGRect) {
        self.currentWeight = currentWeight
        self.goalWeight = goalWeight
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        drawBarProgressBar(rect)
    }

    func drawBarProgressBar(rect: CGRect) {
        let barWidth = rect.size.width - 40 //add some padding to the bar
        let barHeight = rect.size.height - 20
        let pxPerKg = (barWidth/2) / goalWeight
        let fullBarRectPath = UIBezierPath(rect: CGRect(x: 20, y: 10, width: barWidth, height: barHeight))
        let progressBarRectPath = UIBezierPath(rect: CGRect(x: 20, y: 10, width: CGFloat(Int(currentWeight * pxPerKg)), height: barHeight))
        //Round to an integer value (this ensures crispness) but the function accepts only CGFloats so cast the int back to a CGFloat
        
        let fullBarLayer = CAShapeLayer()
        fullBarLayer.path = fullBarRectPath.CGPath
        fullBarLayer.strokeColor = UIColor.blackColor().CGColor
        fullBarLayer.fillColor = UIColor.lightGrayColor().CGColor
        fullBarLayer.lineWidth = 2
        self.layer.addSublayer(fullBarLayer)
        
        let progressBarLayer = CAShapeLayer()
        progressBarLayer.path = progressBarRectPath.CGPath
        progressBarLayer.strokeColor = UIColor.blackColor().CGColor
        progressBarLayer.fillColor = UIColor.redColor().CGColor
        progressBarLayer.lineWidth = 2
        self.layer.addSublayer(progressBarLayer)
        
        let goalMarkerLayer = CAShapeLayer()
        goalMarkerLayer.path = CGPathCreateWithRect(CGRect(x: rect.size.width/2, y: 10, width: 1, height: barHeight), nil)
        goalMarkerLayer.lineWidth = 1
        goalMarkerLayer.strokeColor = UIColor.blackColor().CGColor
        self.layer.addSublayer(goalMarkerLayer)

        let goalString = NSString(format: "Goal: %1.2f kg", Double(goalWeight))
        let goalStringSize = goalString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
        
        let goalTextLayer = CATextLayer()
        goalTextLayer.string = goalString
        goalTextLayer.fontSize = 12
        goalTextLayer.font = UIFont.systemFontOfSize(12)
        goalTextLayer.foregroundColor = UIColor.blackColor().CGColor
        goalTextLayer.frame = CGRectMake(0, 0, goalStringSize.width, goalStringSize.height);
        goalTextLayer.position.x = (rect.size.width / 2)
        goalTextLayer.position.y = (rect.size.height)
        goalTextLayer.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(goalTextLayer)

        let weightTextString = NSString(format: "Weight: %1.2f kg", Double(currentWeight))
        let weightTextSize = weightTextString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        
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
