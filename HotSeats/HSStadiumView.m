//
//  HSStadiumView.m
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import "HSStadiumView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "HSStadium.h"
#import "HSSection.h"
#import "HSStadiumCoordinateParser.h"

@implementation HSStadiumView
@synthesize stadium = _stadium;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString* stadiumFilePath = [[NSBundle mainBundle] pathForResource: @"FenwayFixed" ofType: @"csv"];
        self.stadium = [HSStadiumCoordinateParser parseStadiumFile: stadiumFilePath];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Initialization code
        NSString* stadiumFilePath = [[NSBundle mainBundle] pathForResource: @"FenwayFixed" ofType: @"csv"];
        self.stadium = [HSStadiumCoordinateParser parseStadiumFile: stadiumFilePath];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat maxX = rect.size.width;
    CGFloat maxY = rect.size.height;
    
    const CGFloat stadiumWidth = 973.0;
    const CGFloat stadiumHeight = 812.0;
    
    NSLog(@"Starting Drawing");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5);
    
    for (HSSection* section in self.stadium.sections){
        CGContextBeginPath(context);
        
        for (NSUInteger corner = 0; corner < section.xs.count; corner++){
            CGFloat x = [[section.xs objectAtIndex: corner] floatValue];
            CGFloat y = [[section.ys objectAtIndex: corner] floatValue];
            
            if(corner == 0){
                CGContextMoveToPoint(context, ((x/stadiumWidth) * maxX), ((y/stadiumHeight) * maxY));
            }
            else{
                CGContextAddLineToPoint(context, ((x/stadiumWidth) * maxX), ((y/stadiumHeight) * maxY));
            }
        }
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
/*
    static const CGFloat xs[] = {753.0, 786.0, 786.0, 753.0};
    static const CGFloat ys[] = {521.0, 521.0, 554.0, 538.0};
    
    static const CGFloat xs2[] = {753.0, 786.0, 748.0, 732.0};
    static const CGFloat ys2[] = {540.0, 557.0, 590.0, 571.0};
    
    // Drawing code
    NSLog(@"Starting Drawing");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, ((xs[0]/stadiumWidth) * maxX), ((ys[0]/stadiumHeight) * maxY));
    CGContextAddLineToPoint(context, ((xs[1]/stadiumWidth) * maxX), ((ys[1]/stadiumHeight) * maxY));
    CGContextAddLineToPoint(context, ((xs[2]/stadiumWidth) * maxX), ((ys[2]/stadiumHeight) * maxY));
    CGContextAddLineToPoint(context, ((xs[3]/stadiumWidth) * maxX), ((ys[3]/stadiumHeight) * maxY));
    
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, ((xs2[0]/stadiumWidth) * maxX), ((ys2[0]/stadiumHeight) * maxY));
    CGContextAddLineToPoint(context, ((xs2[1]/stadiumWidth) * maxX), ((ys2[1]/stadiumHeight) * maxY));
    CGContextAddLineToPoint(context, ((xs2[2]/stadiumWidth) * maxX), ((ys2[2]/stadiumHeight) * maxY));
    CGContextAddLineToPoint(context, ((xs2[3]/stadiumWidth) * maxX), ((ys2[3]/stadiumHeight) * maxY));
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
 */
}

@end
