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
#import "HotSeats-Swift.h"

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

- (void) initializeSectionMask;

- (void) drawStaticComponents: (CGContextRef) context;
- (void) drawMound: (CGContextRef) context;
- (void) drawDugouts: (CGContextRef) context;
- (void) drawOuterWall: (CGContextRef) context;
- (void) drawPathInContext: (CGContextRef) context forSection: (HSSection*) sect;

- (void) drawSection: (HSSection*) sect
           withIndex: (NSUInteger) idx
  inOffScreenContext: (CGContextRef) ctx;

@end

@implementation HSStadiumView
@synthesize stadium = _stadium;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeSectionMask];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
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
    _bitmapData = calloc(self.frame.size.width * self.frame.size.height * 4, 1);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    self.maskContext = CGBitmapContextCreate(_bitmapData,
                                             self.frame.size.width,
                                             self.frame.size.height,
                                             8,
                                             self.frame.size.width * 4,
                                             colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
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
#define DRAW_ALL    1
#if DRAW_ALL
    for (HSSection* section in self.stadium.sections){
#else
        HSSection* section = [self.stadium.sections objectAtIndex: 10];
#endif
        CGFloat hue = BLUE_HUE - ((BLUE_HUE - RED_HUE) * (x / max));
        CGContextSetFillColorWithColor(context, [[UIColor colorWithHue: hue/360.0
                                                            saturation: FILL_S
                                                            brightness: FILL_B
                                                                 alpha: 1.0] CGColor]);
        [self drawPathInContext: context forSection: section];

        CGContextDrawPath(context, kCGPathFillStroke);
        
        // Draw the section in the offscreen layer
        //[self drawSection: section
        //        withIndex: sectIndex
        // inOffScreenContext: self.maskContext];

        ++x;
        sectIndex++;
#if DRAW_ALL
    }
#endif
}

- (unsigned char) readPixelDataFromPoint: (CGPoint) p
{
    CGFloat col = p.x;
    CGFloat row = p.y;
    long bytes_per_row = self.bounds.size.width * 4;
    long startByte = (row * bytes_per_row) + (col * 4);
    
    unsigned char byte = ((unsigned char*)_bitmapData)[startByte];
    unsigned char byte1 = ((unsigned char*)_bitmapData)[startByte + 1];
    unsigned char byte2 = ((unsigned char*)_bitmapData)[startByte + 2];
    unsigned char byte3 = ((unsigned char*)_bitmapData)[startByte + 3];
    
    for (NSUInteger w = 0; w < self.frame.size.width; w++) {
        for (NSUInteger h = 0; h < self.frame.size.height; h++) {
            NSUInteger offset = (h * self.frame.size.width) + w;
            unsigned char innerbyte = ((unsigned char*)_bitmapData)[offset];
            if(innerbyte != 0)
                NSLog(@"Index: %lu;;;ByteVal = %u", (unsigned long)offset, innerbyte);
        }
    }
    
    return byte;
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

#define WITH_LAYERS 1
#if WITH_LAYERS

- (void) drawPathInContext: (CGContextRef) context forSection: (HSSection *) sect
{
    CGFloat frameWidth = self.frame.size.width;
    CGFloat frameHeight = self.frame.size.height;
    CGFloat minX, minY = 0.0f;
    CGFloat maxX = frameWidth;
    CGFloat maxY = frameHeight;
    //CGContextBeginPath(context);
    
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
    
#define FULL_FRAMES 0
#if FULL_FRAMES
    minX = 0;
    maxX = self.bounds.size.width;
    minY = 0;
    maxY = self.bounds.size.height;
#endif
    
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
    sectLayer.fillColor = [UIColor blueColor].CGColor;
    //sectLayer.backgroundColor = [UIColor yellowColor].CGColor;
    
    [self.layer addSublayer: sectLayer];
}

#else

- (void) drawPathInContext: (CGContextRef) context forSection: (HSSection *) sect
{
    CGFloat frameWidth = self.frame.size.width;
    CGFloat frameHeight = self.frame.size.height;
    CGFloat minX, minY = 0.0f;
    CGFloat maxX = frameWidth;
    CGFloat maxY = frameHeight;
    //CGContextBeginPath(context);
    
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
    
#define FULL_FRAMES 0
#if FULL_FRAMES
    minX = 0;
    maxX = self.bounds.size.width;
    minY = 0;
    maxY = self.bounds.size.height;
#endif
    
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
    
    UIButton* sectView = [UIButton buttonWithType: UIButtonTypeCustom];

    sectView.opaque = NO;
    [sectView addTarget: self action: @selector(tappedSection:) forControlEvents: UIControlEventTouchUpInside];
    sectView.frame = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    
    HSSectLayer * sectLayer = [[CAShapeLayer alloc] init];
    sectLayer.frame = sectView.bounds;
    sectLayer.path = mutPath;
    sectLayer.opaque = NO;
    sectLayer.fillColor = [UIColor blueColor].CGColor;
    
    [sectView.layer addSublayer: sectLayer];
    
    [self addSubview: sectView];
}

#endif

- (void) tappedSection: (id) target
{
    NSLog(@"Target %@", target);
    [((UIButton*) target) setBackgroundColor: [UIColor yellowColor]];
}

- (void) drawSection: (HSSection*) sect withIndex: (NSUInteger) idx inOffScreenContext: (CGContextRef) ctx
{
    CGContextSetRGBFillColor( ctx, ((CGFloat)idx / 1000.0f), 0.0f, 0.0f, 1.0);
    
    [self drawPathInContext: ctx forSection: sect];
    
    CGContextFillPath(ctx);
}

@end
