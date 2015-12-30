//
//  HSStadiumView.m
//  HotSeats
//
//  Created by rking on 4/22/13.
//  Copyright (c) 2013 rking. All rights reserved.
//

#import "HSStadiumView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "HotSeats-Swift.h"

#define STROKE_R    0.839216
#define STROKE_G    0.031373
#define STROKE_B    0.113725

#define RED_HUE     0.0
#define BLUE_HUE    238.0
#define FILL_S      1.0
#define FILL_B      0.90

#define GREY_FILL_R 0.403921
#define GREY_FILL_G 0.411764
#define GREY_FILL_B 0.419607

@interface HSStadiumView()

- (void) initializeSectionMask;

- (void) drawStaticComponents: (CGContextRef) context;
- (void) drawMound: (CGContextRef) context;
- (void) drawDugouts: (CGContextRef) context;
- (void) drawOuterWall: (CGContextRef) context;
- (void) drawPathInContext: (CGContextRef) context forSection: (HSSection*) sect withFillColor: (UIColor*) fill;

@end

@implementation HSStadiumView
@synthesize stadium;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeSectionMask];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Initialization code
        [self initializeSectionMask];
    }
    return self;
}

- (void)initializeSectionMask
{
    NSString* stadiumFilePath = [[NSBundle mainBundle] pathForResource: @"fenway_test" ofType: @"csv"];
    self.stadium = [HSStadiumCoordinateParser parseStadium: stadiumFilePath];
}
         
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //[self drawStaticComponents: context];
    
    CGContextSetRGBStrokeColor(context, STROKE_R, STROKE_G, STROKE_B, 1.0);
    CGFloat x = 0.0f;
    NSUInteger sectIndex = 0;
    CGFloat max = [self.stadium.sections count];
    CGContextRef bgContext = self.maskContext;
    self.maskContext = context;
    context = bgContext;
    
    for (HSSection* section in self.stadium.sections){
        CGFloat hue = BLUE_HUE - ((BLUE_HUE - RED_HUE) * (x / max));
        UIColor* fillColor = [UIColor colorWithHue: hue/360.0
                                        saturation: FILL_S
                                        brightness: FILL_B
                                             alpha:1.0];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        [self drawPathInContext: context forSection: section withFillColor: fillColor];

        CGContextDrawPath(context, kCGPathFillStroke);
        

        ++x;
        sectIndex++;
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
    
    [self drawPathInContext: context forSection: self.stadium.homeDugout withFillColor: [UIColor blueColor]];

    CGContextDrawPath(context, kCGPathFillStroke);

    [self drawPathInContext: context forSection: self.stadium.visitorDugout withFillColor: [UIColor blueColor]];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void) drawOuterWall: (CGContextRef) context
{
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);

    [self drawPathInContext: context forSection: self.stadium.outerWall withFillColor: [UIColor blueColor]];
    
    CGContextStrokePath(context);
}

- (void) drawPathInContext: (CGContextRef) context forSection: (HSSection*) sect withFillColor: (UIColor *) fill
{
    CGFloat frameWidth = self.frame.size.width;
    CGFloat frameHeight = self.frame.size.height;
    CGFloat minX, minY = 0.0f;
    CGFloat maxX = frameWidth;
    CGFloat maxY = frameHeight;
    
    CGPoint firstPoint = [sect getCoordAtIndex: 0];
    minX = firstPoint.x * frameWidth;
    minY = firstPoint.y * frameHeight;
    maxX = firstPoint.x * frameWidth;
    maxY = firstPoint.y * frameHeight;

    for (NSUInteger corner = 1; corner < sect.coords.count; corner++){
        CGPoint coord = [sect getCoordAtIndex: corner];
        
        minX = MIN(minX, coord.x * frameWidth);
        minY = MIN(minY, coord.y * frameHeight);
        maxX = MAX(maxX, coord.x * frameWidth);
        maxY = MAX(maxY, coord.y * frameHeight);
    }
    
    /**
     * Look at the Ray Wenderlich tutorial and consider using a UIBezierPath
     * instead of CoreGraphics.
     */
    
    // Build the path object
    CGMutablePathRef mutPath = CGPathCreateMutable();
    CGPoint internalFirstPoint = [sect getCoordAtIndex: 0];
    CGPathMoveToPoint(mutPath, NULL, (internalFirstPoint.x * frameWidth) - minX,
                      ((internalFirstPoint.y * frameHeight) - minY));
    
    for (NSUInteger corner = 0; corner < sect.coords.count; corner++) {
        CGPoint coord = [sect getCoordAtIndex: corner];
        CGPathAddLineToPoint(mutPath, NULL, (coord.x * frameWidth) - (minX), ((coord.y * frameHeight) - (minY)));
    }
    
    CGPathCloseSubpath(mutPath);

    HSSectLayer* sectLayer = [[HSSectLayer alloc] init];
    sectLayer.frame = CGRectMake(minX, minY, (maxX) - (minX), (maxY) - (minY));
    sectLayer.path = mutPath;
    
    // TODO: This should be the hue value of the section's 'heat'
    sectLayer.fillColor = fill.CGColor;
    
    //sectLayer.backgroundColor = [UIColor yellowColor].CGColor;
    
    [self.layer addSublayer: sectLayer];
}

- (void) tappedSection: (id) target
{
    NSLog(@"Target %@", target);
    [((UIButton*) target) setBackgroundColor: [UIColor yellowColor]];
}

@end
