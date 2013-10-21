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

#define DATA_FILE_NAME  @"fenway_test"

@implementation HSStadiumView
@synthesize stadium = _stadium;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString* stadiumFilePath = [[NSBundle mainBundle] pathForResource: DATA_FILE_NAME ofType: @"csv"];
        self.stadium = [HSStadiumCoordinateParser parseStadiumFile: stadiumFilePath];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Initialization code
        NSString* stadiumFilePath = [[NSBundle mainBundle] pathForResource: DATA_FILE_NAME ofType: @"csv"];
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
    
    //const CGFloat stadiumWidth = 973.0;
    //const CGFloat stadiumHeight = 812.0;
    const CGFloat stadiumWidth = 1.0;
    const CGFloat stadiumHeight = 1.0;
    
    
    NSLog(@"Starting Drawing");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 214.0/255.0, 8.0/255.0, 29.0/255.0, 1.0);
    CGContextSetRGBFillColor(context, 12.0/255.0, 35.0/255.0, 67.0/255.0, 0.9);
    
    for (HSSection* section in self.stadium.sections){
        if ([section.name isEqualToString: @"outer-wall"]){
            
            NSLog(@"Drawing outer wall");
            CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
            //CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.0f);
            
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
            CGContextDrawPath(context, kCGPathStroke);

        }
        else if([section.name isEqualToString: @"mound-center"]){
            NSLog(@"Drawing mound");
            CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
            //CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.0f);
            
            CGFloat x = [[section.xs firstObject] floatValue];
            CGFloat y = [[section.ys firstObject] floatValue];
            
            CGContextAddArc(context, x*maxX, y*maxY, 5.0f, 0, M_PI*2, YES);
            
            CGContextDrawPath(context, kCGPathStroke);

        }
        else{
            
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
