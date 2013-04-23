//
//  HSSection.m
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import "HSSection.h"

@implementation HSSection

@synthesize xs = _xs;
@synthesize ys = _ys;
@synthesize name = _name;

- (id) initWithName: (NSString *) sectName
{
    self = [super init];
    if(self){
        _xs = [[NSMutableArray alloc] init];
        _ys = [[NSMutableArray alloc] init];
        self.name = sectName;
    }
    
    return self;
}

- (void) dealloc
{
    self.xs = nil;
    self.ys = nil;
    self.name = nil;
}

@end
