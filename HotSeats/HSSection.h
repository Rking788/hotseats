//
//  HSSection.h
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSection : NSObject

// The coordinates for the sections will be stored as NSValue objects
// in an NSMutableArray. This is because you can't directly store CGPoint
// values in NSArrays
@property (strong, nonatomic) NSMutableArray* coords;
@property (strong, nonatomic) NSString* name;

- (instancetype) initWithName: (NSString*) sectName;

- (void) addCoord: (CGPoint) coord;
- (CGPoint) getCoordAtIndex: (NSUInteger) index;

@end
