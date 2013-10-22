//
//  HSStadiumCoordinateParser.m
//  HotSeats
//
//  Created by Robert King on 4/22/13.
//  Copyright (c) 2013 Robert King. All rights reserved.
//

#import "HSStadiumCoordinateParser.h"
#import "HSStadium.h"
#import "HSSection.h"

@implementation HSStadiumCoordinateParser

+ (HSStadium*) parseStadiumFile:(NSString *)stadiumFilePath
{
    HSStadium* stadium = [[HSStadium alloc] init];

    NSString *entireFileInString = [NSString stringWithContentsOfFile: stadiumFilePath encoding: NSUTF8StringEncoding error: nil];
    
    NSArray *lines = [entireFileInString componentsSeparatedByString:@"\n"]; // each line, adjust character for line endings

    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString: @"\"\n\r"];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    for (NSString *line in lines) {
        NSArray* sectionComponents = [line componentsSeparatedByString: @";"];
        NSString* sectionNum = [sectionComponents firstObject];
        
        if([sectionNum isEqualToString: @"mound-center"]) {
            NSString* coordStr = [[sectionComponents objectAtIndex: 1] stringByTrimmingCharactersInSet: charSet];
            if([coordStr isEqualToString: @""])
                continue;
            NSArray* sectComps = [coordStr componentsSeparatedByString: @","];
            
            NSNumber* currentX = [formatter numberFromString: [sectComps firstObject]];
            NSNumber* currentY = [formatter numberFromString: [sectComps objectAtIndex: 1]];
            stadium.moundCenter = CGPointMake([currentX floatValue], [currentY floatValue]);
        }
        else if([sectionNum hasSuffix: @"dugout"]) {
            
            for (NSUInteger coordNum = 1; coordNum < [sectionComponents count]; coordNum++){
                NSString* coordStr = [[sectionComponents objectAtIndex: coordNum] stringByTrimmingCharactersInSet: charSet];
                if([coordStr isEqualToString: @""])
                    continue;
                NSArray* sectComps = [coordStr componentsSeparatedByString: @","];
                
                NSNumber* currentX = [formatter numberFromString: [sectComps firstObject]];
                NSNumber* currentY = [formatter numberFromString: [sectComps objectAtIndex: 1]];
                if ([sectionNum hasPrefix: @"home"]) {
                    [stadium.homeDugout.xs addObject: currentX];
                    [stadium.homeDugout.ys addObject: currentY];
                }
                else {
                    [stadium.visitorDugout.xs addObject: currentX];
                    [stadium.visitorDugout.ys addObject: currentY];
                }
            }
        }
        else if([sectionNum isEqualToString: @"outer-wall"]) {
            for (NSUInteger coordNum = 1; coordNum < [sectionComponents count]; coordNum++){
                NSString* coordStr = [[sectionComponents objectAtIndex: coordNum] stringByTrimmingCharactersInSet: charSet];
                if([coordStr isEqualToString: @""])
                    continue;
                NSArray* sectComps = [coordStr componentsSeparatedByString: @","];
                
                NSNumber* currentX = [formatter numberFromString: [sectComps firstObject]];
                NSNumber* currentY = [formatter numberFromString: [sectComps objectAtIndex: 1]];
                [stadium.outerWall.xs addObject: currentX];
                [stadium.outerWall.ys addObject: currentY];
            }
        }
        else {
            HSSection* sect = [[HSSection alloc] initWithName: sectionNum];
        
            for (NSUInteger coordNum = 1; coordNum < [sectionComponents count]; coordNum++){
                NSString* coordStr = [[sectionComponents objectAtIndex: coordNum] stringByTrimmingCharactersInSet: charSet];
                if([coordStr isEqualToString: @""])
                    continue;
                NSArray* sectComps = [coordStr componentsSeparatedByString: @","];
                
                NSNumber* currentX = [formatter numberFromString: [sectComps firstObject]];
                NSNumber* currentY = [formatter numberFromString: [sectComps objectAtIndex: 1]];
                [sect.xs addObject: currentX];
                [sect.ys addObject: currentY];
            }
            
            [stadium.sections addObject: sect];
        }
        
       
    }
    
    return stadium;
}

@end
