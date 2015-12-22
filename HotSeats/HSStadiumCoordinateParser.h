//
//  HSStadiumCoordinateParser.h
//  HotSeats
//
//  Created by rking on 4/22/13.
//  Copyright (c) 2013 rking. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSStadium;

@interface HSStadiumCoordinateParser : NSObject 

+ (HSStadium*) parseStadiumFile: (NSString*) stadiumFilePath;

@end
