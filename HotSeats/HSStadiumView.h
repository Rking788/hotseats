//
//  HSStadiumView.h
//  HotSeats
//
//  Created by rking on 4/22/13.
//  Copyright (c) 2013 rking. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSStadium;

@interface HSStadiumView : UIView {
    HSStadium* _stadium;
    void* _bitmapData;
}

@property (assign, nonatomic) CGContextRef maskContext;
@property (strong, nonatomic) HSStadium* stadium;

- (unsigned char) readPixelDataFromPoint: (CGPoint) p;

@end
