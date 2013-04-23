//
//  HSStadiumCoordinateParser.h
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSStadium;

@interface HSStadiumCoordinateParser : NSObject {
    
}

+ (HSStadium*) parseStadiumFile: (NSString*) stadiumFilePath;

@end
