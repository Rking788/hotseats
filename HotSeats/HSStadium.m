//
//  HSStadium.m
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import "HSStadium.h"

@implementation HSStadium 

@synthesize sections = _sections;

- (id) init
{
    self = [super init];
  
    if(self){
        _sections = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    self.sections = nil;
}

@end
