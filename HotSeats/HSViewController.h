//
//  HSViewController.h
//  HotSeats
//
//  Created by Robert King on 2/28/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStadiumView.h"

@interface HSViewController : UIViewController
{
    HSStadiumView* _stadiumView;
}

@property (strong, nonatomic) HSStadiumView *stadiumView;

@end
