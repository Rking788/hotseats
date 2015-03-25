//
//  HSViewController.m
//  HotSeats
//
//  Created by Robert King on 2/28/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import <KinveyKit/KinveyKit.h>
#import "HSViewController.h"
#import "HSStadiumCoordinateParser.h"

#define DATA_FILE_NAME  @"fenway_test"

@interface HSViewController ()

@end

@implementation HSViewController

@synthesize stadiumView = _stadiumView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    /**
     * TODO: This should check if a stadium has already been selected,
     * otherwise prompt the user to select one.
     */
    NSString* stadiumFilePath = [[NSBundle mainBundle] pathForResource: DATA_FILE_NAME ofType: @"csv"];
    
    // Offset the view's frame by 20 to avoid drawing in the "status bar"
    CGRect stadiumFrame = CGRectMake(0.0f,
                                     self.view.frame.origin.y + 20.0f,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height - 20.0f);
    _stadiumView = [[HSStadiumView alloc] initWithFrame: stadiumFrame];
    _stadiumView.stadium = [HSStadiumCoordinateParser parseStadiumFile: stadiumFilePath];
    _stadiumView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _stadiumView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(stadiumTapped:)];
    [self.stadiumView addGestureRecognizer: tapGesture];
    [self.view addSubview: self.stadiumView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void) stadiumTapped: (UITapGestureRecognizer*) sender
{
    NSLog(@"Tapped the stadium");
    CGPoint tapLoc = [sender locationInView: self.stadiumView];
    NSLog(@"Sublayer count; %d", self.stadiumView.layer.sublayers.count);
    NSLog(@"layer contains point = %d", [self.stadiumView.layer containsPoint: tapLoc]);
    CALayer* tappedLayer = [self.stadiumView.layer hitTest: tapLoc];
    NSLog(@"Found layer = %d", tappedLayer == nil);
    for (CALayer* layer in self.stadiumView.layer.sublayers) {
        CALayer* hitLayer = [layer hitTest: tapLoc];
        if (hitLayer != nil) {
            [hitLayer setBackgroundColor: [UIColor orangeColor].CGColor];
            break;
        }
    }
    /*CALayer* layer = [self.stadiumView.layer.sublayers lastObject];
    NSLog(@"Layer hittest: %d", [layer hitTest: tapLoc]);
    if ([layer hitTest: tapLoc]){
        [layer setBackgroundColor: [UIColor orangeColor].CGColor];
    }*/
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    UITouch* touch = [[touches allObjects] firstObject];
    CGPoint loc = [touch locationInView: self.stadiumView];
    [self.stadiumView readPixelDataFromPoint: loc];
}

@end
