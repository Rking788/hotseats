//
//  HSStadiumView.h
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSStadium;

@interface HSStadiumView : UIView {
    HSStadium* _stadium;
}

@property (strong, nonatomic) HSStadium* stadium;

@end
