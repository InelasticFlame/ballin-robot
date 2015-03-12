//
//  Graph.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

    
class Graph: UIView {
    
    private let indent: CGFloat = 10
    private let axesIndent: CGFloat = 30
    private let markerHeight: CGFloat = 5
    
    private var originX: CGFloat = 0
    private var originY: CGFloat = 0
    private var yAxisMax: CGFloat = 0
    private var xAxisMax: CGFloat = 0
    private var yAxisLength: CGFloat = 0
    private var xAxisLength: CGFloat = 0
    private var yScale: CGFloat = 0
    private var xScale: CGFloat = 0
    private var maxYCoord: CGFloat = 0
    private var majorStep: CGFloat = 10
    private var minorStep: CGFloat = 2
    private var graphStyle: GraphStyle
    private var graphType: GraphType
    
    private var values = [GraphCoordinate]()
    
    enum GraphStyle {
        case Line
        case Bar
    }
    
    enum GraphType {
        case Pace
        case Distance
        case Duration
        case Weight
    }
    
    init(frame: CGRect, graphStyle: GraphStyle, coordinates: [GraphCoordinate]) {
        values = coordinates
        self.graphStyle = graphStyle
        self.graphType = .Weight
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.graphStyle = .Line
        self.graphType = .Weight
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        if values.count > 0 {
            originX = axesIndent
            originY = rect.height - axesIndent
            yAxisMax = indent
            xAxisMax = rect.width - indent
            yAxisLength = originY - yAxisMax
            xAxisLength = rect.width - axesIndent - indent
            xScale = xAxisLength/CGFloat(values.count)
            
            if graphType == .Pace {
                majorStep = 60
                minorStep = 10
            } else if graphType == .Duration {
                majorStep = 3600
                minorStep = 600
            }
            
            getYScale()
            
            if graphStyle == .Line {
                xScale = xAxisLength/CGFloat(values.count - 1)
                plotLineGraph()
            } else {
                plotBarGraph()
            }
            
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
                //                if yScale > 5 {
                for markerNo in 0...Int(maxYCoord/minorStep) { //2 MARKERS
                    let yMarkerY = yScale * minorStep * CGFloat(markerNo)
                    CGContextMoveToPoint(currentContext, originX, originY - yMarkerY)
                    CGContextAddLineToPoint(currentContext, originX - markerHeight, originY - yMarkerY)
                    //                    }
                }
                CGContextStrokePath(currentContext)
                CGContextSetLineWidth(currentContext, 2)
            }
            
            //X
            CGContextMoveToPoint(currentContext, axesIndent, rect.height - axesIndent)
            CGContextAddLineToPoint(currentContext, rect.width - indent, rect.height - axesIndent)
            
            for markerNumber in 0...values.count {
                let xMarkerX = xScale * CGFloat(markerNumber)
                CGContextMoveToPoint(currentContext, axesIndent + xMarkerX, rect.height - axesIndent)
                CGContextAddLineToPoint(currentContext, axesIndent + xMarkerX, rect.height - axesIndent + markerHeight)
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
    
    func plotBarGraph() {
        let context = UIGraphicsGetCurrentContext()
        
        for i in 0...values.count - 1 {
            let barRect = CGRect(x: (CGFloat(i) * xScale) + axesIndent + 5, y: frame.height - (values[i].y * yScale) - axesIndent, width: xScale - 10, height: values[i].y * yScale)
            CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
            CGContextFillRect(context, barRect)
        }
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
    
    func yAxisLabel(markerNo: Int) -> String {
        var label = ""
        if graphType == .Pace || graphType == .Duration {
            label = "\(markerNo)"
        } else {
            label = "\(markerNo * Int(majorStep))"
        }
        
        return label
    }
    
}

