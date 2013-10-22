//
//  HSStadium.m
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import "HSStadium.h"
#import "HSSection.h"

@implementation HSStadium 

@synthesize moundCenter = _moundCenter;
@synthesize outerWall = _outerWall;
@synthesize homeDugout = _homeDugout;
@synthesize visitorDugout = _visitorDugout;
@synthesize sections = _sections;


- (id) init
{
    self = [super init];
  
    if(self){
        _moundCenter = CGPointZero;
        _outerWall = [[HSSection alloc] init];
        _homeDugout = [[HSSection alloc] init];
        _visitorDugout = [[HSSection alloc] init];
        _sections = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    self.sections = nil;
    self.outerWall = nil;
    self.homeDugout = nil;
    self.visitorDugout = nil;
}

@end
