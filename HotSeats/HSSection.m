//
//  HSSection.m
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import "HSSection.h"

@implementation HSSection

- (instancetype) init
{
    self = [super init];
    if(self){
        _coords = [[NSMutableArray alloc] init];
        self.name = @"";
    }
    
    return self;
}

- (instancetype) initWithName: (NSString *) sectName
{
    self = [super init];
    if(self){
        _coords = [[NSMutableArray alloc] init];
        self.name = sectName;
    }
    
    return self;
}

- (void) dealloc
{
    self.coords = nil;
    self.name = nil;
}

- (void) addCoord: (CGPoint) coord
{
    [self.coords addObject: [NSValue valueWithCGPoint: coord]];
}

- (CGPoint) getCoordAtIndex: (NSUInteger) index
{
    return [[self.coords objectAtIndex: index] CGPointValue];
}

@end
