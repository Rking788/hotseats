//
//  StadiumView.swift
//  HotSeats
//
//  Created by RPK on 12/29/15.
//  Copyright © 2015 Robert King. All rights reserved.
//

import UIKit

// TODO: What is the Swift-y way of doing this?
let STROKE_R =   CGFloat(0.839216)
let STROKE_G =   CGFloat(0.031373)
let STROKE_B =   CGFloat(0.113725)

let RED_HUE  =   CGFloat(0.0)
let BLUE_HUE =   CGFloat(238.0)
let FILL_S   =   CGFloat(1.0)
let FILL_B   =   CGFloat(0.90)

let GREY_FILL_R = CGFloat(0.403921)
let GREY_FILL_G = CGFloat(0.411764)
let GREY_FILL_B = CGFloat(0.419607)

class StadiumView: UIView {

    var stadium: Stadium!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeStadium() {
        let stadiumFilePath = NSBundle.mainBundle().pathForResource("fenway_test", ofType: "csv")
        self.stadium = StadiumCoordinateParser.parseStadium(stadiumFilePath!)
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let ctx = UIGraphicsGetCurrentContext()
        
        self.drawStaticComponents(ctx!)
        
        CGContextSetRGBStrokeColor(ctx, STROKE_R, STROKE_G, STROKE_B, 1.0)
        var x: CGFloat = 0.0
        var sectIndex = 0
        let max = CGFloat(self.stadium.sections.count)
        
        for section in self.stadium.sections {
            
            let hue = BLUE_HUE - ((BLUE_HUE - RED_HUE) * (x / max))
            let fillColor = UIColor(hue: CGFloat(hue/360.0),
                saturation: FILL_S,
                brightness: FILL_B,
                alpha: 1.0)
            
            CGContextSetFillColorWithColor(ctx, fillColor.CGColor)
            self.drawPathInContext(ctx!, section: section, fillColor: fillColor)
            
            CGContextDrawPath(ctx, .FillStroke)
            
            ++x
            sectIndex++
        }
    }

    // MARK: Private Methods
    
    func drawStaticComponents(ctx: CGContextRef) {
        self.drawMound(ctx)
        self.drawDugouts(ctx)
        self.drawOuterWall(ctx)
    }
    
    func drawMound(ctx: CGContextRef) {
        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0)
        
        let x = self.stadium.moundCenter.x
        let y = self.stadium.moundCenter.y
        
        CGContextAddArc(ctx, x * self.frame.size.width,
            y * self.frame.size.height, 5.0, 0, CGFloat(M_PI * 2.0), 1)
        
        CGContextStrokePath(ctx)
    }
    
    func drawDugouts(ctx: CGContextRef) {
        CGContextSetRGBStrokeColor(ctx, STROKE_R, STROKE_G, STROKE_B, 1.0)
        CGContextSetRGBFillColor(ctx, GREY_FILL_R, GREY_FILL_G, GREY_FILL_B, 1.0)
        
        self.drawPathInContext(ctx, section: self.stadium.homeDugout, fillColor: UIColor.blueColor())
        
        CGContextDrawPath(ctx, .FillStroke)
        
        self.drawPathInContext(ctx, section: self.stadium.visitorDugout, fillColor: UIColor.blueColor())
        
        CGContextDrawPath(ctx, .FillStroke)
    }
    
    func drawOuterWall(ctx: CGContextRef) {
        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0)
        
        self.drawPathInContext(ctx, section: self.stadium.outerWall, fillColor: UIColor.clearColor(), strokeColor: UIColor.blueColor())
        
        CGContextStrokePath(ctx)
    }
    
    func drawPathInContext( ctx: CGContextRef, section: Section, fillColor: UIColor, strokeColor: UIColor = UIColor.clearColor()) {
        let frameWidth = self.frame.size.width
        let frameHeight = self.frame.size.height
        var minX: CGFloat = 0.0
        var minY: CGFloat = 0.0
        var maxX = frameWidth
        var maxY = frameHeight
        
        let firstPoint = section.getCoordAtIndex(0)
        minX = firstPoint.x * frameWidth
        minY = firstPoint.y * frameHeight
        maxX = firstPoint.x * frameWidth
        maxY = firstPoint.y * frameHeight
        
        for coord in section.coords {

            minX = min(minX, CGFloat(coord.x) * frameWidth)
            minY = min(minY, CGFloat(coord.y) * frameHeight)
            maxX = max(maxX, CGFloat(coord.x) * frameWidth)
            maxY = max(maxY, CGFloat(coord.y) * frameHeight)
        }
        
        /**
        * TODO: Look at the Ray Wenderlich tutorial and consider using a UIBezierPath
        * instead of CoreGraphics.
        */
        
        // Build the path object
        let mutPath = CGPathCreateMutable();
        let internalFirstPoint = section.getCoordAtIndex(0)
        CGPathMoveToPoint(mutPath, nil, (internalFirstPoint.x * frameWidth) - minX,
            ((internalFirstPoint.y * frameHeight) - minY))
        
        for coord in section.coords {
            
            CGPathAddLineToPoint(mutPath, nil, (CGFloat(coord.x) * frameWidth) - (minX), ((CGFloat(coord.y) * frameHeight) - (minY)))
        }
        
        CGPathCloseSubpath(mutPath)
        
        let sectLayer = HSSectLayer()
        sectLayer.section = section
        sectLayer.selectable = section.selectable
        sectLayer.frame = CGRectMake(minX, minY, (maxX) - (minX), (maxY) - (minY))
        sectLayer.path = mutPath
        
        // TODO: This should be the hue value of the section's 'heat'
        sectLayer.fillColor = fillColor.CGColor
        sectLayer.strokeColor = strokeColor.CGColor
        
        //sectLayer.backgroundColor = [UIColor yellowColor].CGColor;
        
        self.layer.addSublayer(sectLayer)
    }
    
    func tappedSection( target: AnyObject) {
        // TODO: Not actually called?
        NSLog("Target \(target)")
        (target as! UIButton).backgroundColor = UIColor.yellowColor()
    }
}
