//
//  HSStadium.h
//  HotSeats
//
//  Created by rking on 4/22/13.
//  Copyright (c) 2013 rking. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSSection;

@interface HSStadium : NSObject {
    CGPoint _moundCenter;
    HSSection* _outerWall;
    HSSection* _homeDugout;
    HSSection* _visitorDugout;
    NSMutableArray* _sections;
}

@property (assign, nonatomic) CGPoint moundCenter;
@property (strong, nonatomic) HSSection* outerWall;
@property (strong, nonatomic) HSSection* homeDugout;
@property (strong, nonatomic) HSSection* visitorDugout;
@property (strong, nonatomic) NSMutableArray* sections;

@end
