//
//  HSStadiumCoordinateParser.m
//  HotSeats
//
//  Created by rking on 4/22/13.
//  Copyright (c) 2013 rking. All rights reserved.
//

#import "HSStadiumCoordinateParser.h"
#import "HSStadium.h"
#import "HSSection.h"

@interface HSStadiumCoordinateParser ()

+ (void) parseCoordsFromComps: (NSArray*) comps forSection: (HSSection*) sect;

@end

@implementation HSStadiumCoordinateParser

+ (HSStadium*) parseStadiumFile:(NSString *)stadiumFilePath
{
    HSStadium* stadium = [[HSStadium alloc] init];

    NSString *entireFileInString = [NSString stringWithContentsOfFile: stadiumFilePath encoding: NSUTF8StringEncoding error: nil];
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString: @"\"\n\r"];
    
    // each line, adjust character for line endings
    NSArray *lines = [entireFileInString componentsSeparatedByString:@"\n"];
    HSSection* currentSect;
    for (NSString *line in lines) {
        NSArray* sectionComponents = [line componentsSeparatedByString: @";"];
        NSString* sectionNum = [sectionComponents firstObject];
        currentSect = nil;
        
        if([sectionNum isEqualToString: @"mound-center"]) {
            NSString* coordStr = [[sectionComponents objectAtIndex: 1] stringByTrimmingCharactersInSet: charSet];
            if([coordStr isEqualToString: @""])
                continue;
            NSArray* sectComps = [coordStr componentsSeparatedByString: @","];
            
            stadium.moundCenter = CGPointMake([[sectComps firstObject] floatValue],
                                              [sectComps[1] floatValue]);
            continue;
        }
        else if([sectionNum hasSuffix: @"dugout"]) {
            if ([sectionNum hasPrefix: @"home"]) {
                currentSect = stadium.homeDugout;
            }
            else {
                currentSect = stadium.visitorDugout;
            }
        }
        else if([sectionNum isEqualToString: @"outer-wall"]) {
            currentSect = stadium.outerWall;
        }
        else {
            currentSect = [[HSSection alloc] initWithName: sectionNum];
            [stadium.sections addObject: currentSect];
        }
        
        [HSStadiumCoordinateParser parseCoordsFromComps: sectionComponents
                                             forSection: currentSect];
    }
    
    return stadium;
}

+ (void) parseCoordsFromComps: (NSArray *) comps forSection: (HSSection *) sect
{
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString: @"\"\n\r"];
    for (NSUInteger coordNum = 1; coordNum < comps.count; coordNum++){
        NSString* coordStr = [[comps objectAtIndex: coordNum] stringByTrimmingCharactersInSet: charSet];
        if([coordStr isEqualToString: @""])
            continue;
        NSArray* sectComps = [coordStr componentsSeparatedByString: @","];
        
        CGFloat currentX = [[sectComps firstObject] floatValue];
        CGFloat currentY = [sectComps[1] floatValue];
        [sect addCoord: CGPointMake( currentX, currentY)];
    }

}

@end
