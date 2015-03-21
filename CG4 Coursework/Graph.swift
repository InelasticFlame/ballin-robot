//
//  Graph.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit
    
class Graph: UIView {
    
    //MARK: - Global Variables
    
    private let indent: CGFloat = 10 //A global constant CGFloat that stores the indent (the gap between the edge of the view and the axes)
    private let axesIndent: CGFloat = 30 //A global constant CGFloat that stores the axesIndent (the gap between the edge of the view and the axes)
    private let markerHeight: CGFloat = 5 //A global constant CGFloat that stores the size of the marks on the axes
    private let majorStep: CGFloat = 10 //A global constant CGFloat that stores the spacing of the majorSteps
    private let minorStep: CGFloat = 2 //A global constant CGFloat that stores the spacing of the minor steps
    
    
    private var originX: CGFloat = 0 //A global variable CGFloat that stores the position of the x coord of the origin
    private var originY: CGFloat = 0 //A global variable CGFloat that stores the position of the y coord of the origin
    private var yAxisMax: CGFloat = 0 //A global variable CGFloat that stores the maximum y coord of the y axis
    private var xAxisMax: CGFloat = 0 //A global variable CGFloat that stores the maximum x coord of the y axis
    private var yAxisLength: CGFloat = 0 //A global variable CGFloat that stores the length of the y axis
    private var xAxisLength: CGFloat = 0 //A global variable CGFloat that stores the length of the x axis
    private var yScale: CGFloat = 0 //A global variable CGFloat that stores the scale of the y axis
    private var xScale: CGFloat = 0 //A global variable CGFloat that stores the scale of the x axis
    private var maxYCoord: CGFloat = 0 //A global variable CGFloat that stores the maximum y coordinate of the data
    
    private let values = [GraphCoordinate]() //A global array of GraphCoordinate objects

    //MARK: - Initialisation
    
    /**
    Called to initialise the class, sets the properties of the Graph to the passed values.
    */
    init(frame: CGRect, coordinates: [GraphCoordinate]) {
        values = coordinates
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    This method is called to draw the graph.
    (Note: (0, 0) is the TOP left corner)
    IF there are coordinates
        1. Set the originX to the axesIndent
        2. Set the originY to the rect height - axesIndent
        3. Set the yAxis max to the value of indent
        4. Set the xAxis max to the rect width - indent
        5. Set the yAxisLength as the originY - yAxisMax
        6. Set the xAxisLength as the rect width - axesIndent - indent
        7.
    */
    override func drawRect(rect: CGRect) {
        if values.count > 0 {
            originX = axesIndent
            originY = rect.height - axesIndent
            yAxisMax = indent
            xAxisMax = rect.width - indent
            yAxisLength = originY - yAxisMax
            xAxisLength = rect.width - axesIndent - indent
            xScale = xAxisLength/CGFloat(values.count)
            
            getYScale()
            xScale = xAxisLength/CGFloat(values.count - 1)
            plotLineGraph()
            
            let currentContext = UIGraphicsGetCurrentContext()
            CGContextSetStrokeColorWithColor(currentContext, UIColor.blackColor().CGColor)
            CGContextSetLineWidth(currentContext, 2)
            
            //Draw Axes
            //Y
            CGContextMoveToPoint(currentContext, originX, originY)
            CGContextAddLineToPoint(currentContext, originX, yAxisMax)
            
            if values.count > 0 {
                for markerNo in 0...Int(maxYCoord/majorStep) { //10 MARKERS
                    let yMarkerY = yScale * majorStep * CGFloat(markerNo)
                    CGContextMoveToPoint(currentContext, originX, originY - yMarkerY)
                    CGContextAddLineToPoint(currentContext, originX - markerHeight, originY - yMarkerY)
                    self.addTextToGraph(self.yAxisLabel(markerNo), xCoord: originX - 20, yCoord: originY - yMarkerY - 5)
                }
                CGContextStrokePath(currentContext)
                CGContextSetLineWidth(currentContext, 0.4)
                for markerNo in 0...Int(maxYCoord/minorStep) { //2 MARKERS
                    let yMarkerY = yScale * minorStep * CGFloat(markerNo)
                    CGContextMoveToPoint(currentContext, originX, originY - yMarkerY)
                    CGContextAddLineToPoint(currentContext, originX - markerHeight, originY - yMarkerY)
                }
                CGContextStrokePath(currentContext)
                CGContextSetLineWidth(currentContext, 2)
            }
            
            //X
            CGContextMoveToPoint(currentContext, axesIndent, rect.height - axesIndent)
            CGContextAddLineToPoint(currentContext, rect.width - indent, rect.height - axesIndent)
            
            for markerNumber in 0...values.count - 1 {
                let xMarkerX = xScale * CGFloat(markerNumber)
                CGContextMoveToPoint(currentContext, axesIndent + xMarkerX, rect.height - axesIndent)
                CGContextAddLineToPoint(currentContext, axesIndent + xMarkerX, rect.height - axesIndent + markerHeight)
                self.addXAxisTextToGraph(self.values[markerNumber].x, xCoord: originX + xMarkerX, yCoord: originY + 60)
            }
            
            CGContextStrokePath(currentContext)
        }
    }
    
    func plotLineGraph() {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        
        CGContextMoveToPoint(context, axesIndent, frame.height - (values[0].y * yScale) - axesIndent)
        for i in 1...values.count - 1 {
            CGContextAddLineToPoint(context, (CGFloat(i) * xScale) + axesIndent, frame.height - (values[i].y * yScale) - axesIndent)
        }
        CGContextStrokePath(context)
    }
    
    func getYScale() {
        var yInterval: CGFloat = 10.0
        var maxYCoord: CGFloat = 0.0
        for coordinate in values {
            if coordinate.y > maxYCoord {
                maxYCoord = coordinate.y
            }
        }
        
        var maxYValue:CGFloat = 0.0

        if maxYCoord % majorStep != 0 {
            maxYValue = (majorStep - (maxYCoord % majorStep)) + maxYCoord //round to nearest 10
        } else {
            maxYValue = maxYCoord
        }
        
        if maxYValue != 0 {
            yInterval = CGFloat(yAxisLength / (maxYValue))
        }
        
        yScale = yInterval
        self.maxYCoord = maxYValue
    }
    
    func addTextToGraph(text: String, xCoord: CGFloat, yCoord: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 10
        textLayer.font = UIFont.systemFontOfSize(10)
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.frame = CGRectMake(xCoord, yCoord, 100, 12);
        textLayer.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(textLayer)
    }
    
    func addXAxisTextToGraph(text: String, xCoord: CGFloat, yCoord: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 10
        textLayer.font = UIFont.systemFontOfSize(10)
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.frame = CGRectMake(xCoord, yCoord, 100, 12);
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI/2)))
        textLayer.position = CGPointMake(xCoord, yCoord)
        self.layer.addSublayer(textLayer)
    }
    
    func yAxisLabel(markerNo: Int) -> String {
        var label = "\(markerNo * Int(majorStep))"
        
        return label
    }
}

