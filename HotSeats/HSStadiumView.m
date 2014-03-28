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
- (void) drawPathInContext: (CGContextRef) context forSection: (HSSection*) sect;

@end

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
        [self drawPathInContext: context forSection: section];

        CGContextDrawPath(context, kCGPathFillStroke);
    
        ++x;
    }
}

#pragma mark - Private Method implementation
- (void) drawStaticComponents: (CGContextRef) context
{
    [self drawMound: context];
    [self drawDugouts: context];
    [self drawOuterWall: context];
}

- (void) drawMound: (CGContextRef) context
{
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    
    CGFloat x = self.stadium.moundCenter.x;
    CGFloat y = self.stadium.moundCenter.y;
    
    CGContextAddArc(context, x * self.frame.size.width, y * self.frame.size.height, 5.0f, 0, M_PI*2, YES);
    
    CGContextStrokePath(context);
}

- (void) drawDugouts: (CGContextRef) context
{
    CGContextSetRGBStrokeColor(context, STROKE_R, STROKE_G, STROKE_B, 1.0);
    CGContextSetRGBFillColor(context, GREY_FILL_R, GREY_FILL_G, GREY_FILL_B, 1.0);
    
    [self drawPathInContext: context forSection: self.stadium.homeDugout];

    CGContextDrawPath(context, kCGPathFillStroke);

    [self drawPathInContext: context forSection: self.stadium.visitorDugout];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void) drawOuterWall: (CGContextRef) context
{
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);

    [self drawPathInContext: context forSection: self.stadium.outerWall];
    
    CGContextStrokePath(context);
}

- (void) drawPathInContext: (CGContextRef) context forSection: (HSSection *) sect
{
    CGFloat frameWidth = self.frame.size.width;
    CGFloat frameHeight = self.frame.size.height;
    CGContextBeginPath(context);
    
    for (NSUInteger corner = 0; corner < sect.coords.count; corner++){
        CGPoint coord = [sect getCoordAtIndex: corner];
        
        if(corner == 0){
            CGContextMoveToPoint(context,
                                 (coord.x * frameWidth),
                                 (coord.y * frameHeight));
        }
        else{
            CGContextAddLineToPoint(context,
                                    (coord.x * frameWidth),
                                    (coord.y * frameHeight));
        }
    }
    
    CGContextClosePath(context);

}

@end
