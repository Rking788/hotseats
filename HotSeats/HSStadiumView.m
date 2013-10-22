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

#define STROKE_R    0.839216
#define STROKE_G    0.031373
#define STROKE_B    0.113725

#define RED_HUE     0.0
#define BLUE_HUE    238.0
#define FILL_S      0.92
#define FILL_B      0.90

#define GREY_FILL_R 0.403921
#define GREY_FILL_G 0.411764
#define GREY_FILL_B 0.419607

@interface HSStadiumView()

- (void) drawStaticComponents: (CGContextRef) context;
- (void) drawMound: (CGContextRef) context;
- (void) drawDugouts: (CGContextRef) context;
- (void) drawOuterWall: (CGContextRef) context;

@end

#pragma mark - TODO: REMOVE REPETITIVE CODE
@implementation HSStadiumView
@synthesize stadium = _stadium;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat maxX = rect.size.width;
    CGFloat maxY = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawStaticComponents: context];
    
    CGContextSetRGBStrokeColor(context, STROKE_R, STROKE_G, STROKE_B, 1.0);
    CGFloat x = 0.0f;
    CGFloat max = [self.stadium.sections count];
    for (HSSection* section in self.stadium.sections){
        CGFloat hue = BLUE_HUE - ((BLUE_HUE - RED_HUE) * (x / max));
        CGContextSetFillColorWithColor(context, [[UIColor colorWithHue: hue/360.0
                                                            saturation: FILL_S
                                                            brightness: FILL_B
                                                                 alpha: 1.0] CGColor]);
        CGContextBeginPath(context);
        
        for (NSUInteger corner = 0; corner < section.xs.count; corner++){
            CGFloat x = [[section.xs objectAtIndex: corner] floatValue];
            CGFloat y = [[section.ys objectAtIndex: corner] floatValue];
            
            if(corner == 0){
                CGContextMoveToPoint(context, (x * maxX), (y * maxY));
            }
            else{
                CGContextAddLineToPoint(context, (x * maxX), (y * maxY));
            }
        }
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    
        ++x;
    }
}

#pragma mark - Private Method implementation
- (void) drawStaticComponents: (CGContextRef) context
{
    [self drawMound: context];
    [self drawOuterWall: context];
    [self drawDugouts: context];
}

- (void) drawMound: (CGContextRef) context
{
    NSLog(@"Drawing mound");
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    
    CGFloat x = self.stadium.moundCenter.x;
    CGFloat y = self.stadium.moundCenter.y;
    
    CGContextAddArc(context, x * self.frame.size.width, y * self.frame.size.height, 5.0f, 0, M_PI*2, YES);
    
    CGContextStrokePath(context);
}

- (void) drawDugouts: (CGContextRef) context
{
    NSLog(@"Drawing outer wall");
    
    CGContextSetRGBStrokeColor(context, STROKE_R, STROKE_G, STROKE_B, 1.0);
    CGContextSetRGBFillColor(context, GREY_FILL_R, GREY_FILL_G, GREY_FILL_B, 1.0);
    
    CGContextBeginPath(context);
    
    for (NSUInteger corner = 0; corner < self.stadium.homeDugout.xs.count; corner++){
        CGFloat x = [[self.stadium.homeDugout.xs objectAtIndex: corner] floatValue];
        CGFloat y = [[self.stadium.homeDugout.ys objectAtIndex: corner] floatValue];
        
        if(corner == 0){
            CGContextMoveToPoint(context, (x * self.frame.size.width), (y * self.frame.size.height));
        }
        else{
            CGContextAddLineToPoint(context, (x * self.frame.size.width), (y * self.frame.size.height));
        }
    }
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

    for (NSUInteger corner = 0; corner < self.stadium.visitorDugout.xs.count; corner++){
        CGFloat x = [[self.stadium.visitorDugout.xs objectAtIndex: corner] floatValue];
        CGFloat y = [[self.stadium.visitorDugout.ys objectAtIndex: corner] floatValue];
        
        if(corner == 0){
            CGContextMoveToPoint(context, (x * self.frame.size.width), (y * self.frame.size.height));
        }
        else{
            CGContextAddLineToPoint(context, (x * self.frame.size.width), (y * self.frame.size.height));
        }
    }
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void) drawOuterWall: (CGContextRef) context
{
    NSLog(@"Drawing outer wall");
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    
    CGContextBeginPath(context);
    
    for (NSUInteger corner = 0; corner < self.stadium.outerWall.xs.count; corner++){
        CGFloat x = [[self.stadium.outerWall.xs objectAtIndex: corner] floatValue];
        CGFloat y = [[self.stadium.outerWall.ys objectAtIndex: corner] floatValue];
        
        if(corner == 0){
            CGContextMoveToPoint(context, (x * self.frame.size.width), (y * self.frame.size.height));
        }
        else{
            CGContextAddLineToPoint(context, (x * self.frame.size.width), (y * self.frame.size.height));
        }
    }
    
    CGContextClosePath(context);
    CGContextStrokePath(context);

}

@end
