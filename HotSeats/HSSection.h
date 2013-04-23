//
//  HSSection.h
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSection : NSObject {
    // TODO: Should change these to CGPoints not separate Xs and Ys
    NSMutableArray* _xs;
    NSMutableArray* _ys;
    NSString* _name;
}

@property (strong, nonatomic) NSMutableArray* xs;
@property (strong, nonatomic) NSMutableArray* ys;
@property (strong, nonatomic) NSString* name;

- (id) initWithName: (NSString*) sectName;

@end
