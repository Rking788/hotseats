//
//  StadiumCoordinateParser.swift
//  HotSeats
//
//  Created by RPK on 12/21/15.
//  Copyright © 2015 Robert King. All rights reserved.
//

import UIKit

@objc(HSStadiumCoordinateParser) class StadiumCoordinateParser: NSObject {
    
    static let lineSepCharSet = NSCharacterSet(charactersInString: "\"\n\r")
    
    class func parseStadium(stadiumFilePath: String) -> Stadium? {
        
        let stadium = Stadium()
        
        do {
            let entireFileInString = try NSString(contentsOfFile: stadiumFilePath, encoding: NSUTF8StringEncoding)
            
            // Each line, adjust character for line endings
            let lines = entireFileInString.componentsSeparatedByCharactersInSet(StadiumCoordinateParser.lineSepCharSet)
            for (_, line) in lines.enumerate() {
                let sectionComponents = line.componentsSeparatedByString(";")
                let sectionNum: String = sectionComponents.first!
                var currentSect: Section? = nil
                
                if sectionNum == "mound-center" {
                    let coordStr = sectionComponents[1].stringByTrimmingCharactersInSet(StadiumCoordinateParser.lineSepCharSet)
                    if coordStr == "" {
                        continue
                    }
                    
                    let sectComps: [NSString] = coordStr.componentsSeparatedByString(",")
                    stadium.moundCenter = CGPointMake(CGFloat(sectComps[0].floatValue), CGFloat(sectComps[1].floatValue))
                    continue
                }
                else if sectionNum.hasSuffix("dugout") {
                    if sectionNum.hasPrefix("home") {
                        currentSect = stadium.homeDugout
                    }
                    else {
                        currentSect = stadium.visitorDugout
                    }
                }
                else if sectionNum == "outer-wall" {
                    currentSect = stadium.outerWall
                }
                else {
                    currentSect = Section(name: sectionNum)
                    //stadium.sections.append(currentSect!)
                    stadium.sections.addObject(currentSect!)
                }
                
                if let sect = currentSect {
                    StadiumCoordinateParser.parseCoords(sectionComponents, section: sect)
                }
                else {
                    NSLog("ERROR: Not parsing coordinates into nil Section!!")
                }
            }
        }
        catch let err as NSError {
            NSLog("Failed to read stadium file!!: \(err.localizedDescription)")
            return nil
        }
        
        return stadium
    }

    private class func parseCoords(comps: [NSString], section: Section) {
        for (_, coordStr) in comps.enumerate() {
            let fixedCoordStr = coordStr.stringByTrimmingCharactersInSet(StadiumCoordinateParser.lineSepCharSet)
            if fixedCoordStr == "" {
                continue
            }
            
            let sectComps: [NSString] = fixedCoordStr.componentsSeparatedByString(",")
            
            if sectComps.count < 2 {
                continue
            }
            
            let currentX: CGFloat = CGFloat(sectComps[0].floatValue)
            let currentY: CGFloat = CGFloat(sectComps[1].floatValue)
            
            section.addCoord(CGPointMake(currentX, currentY))
        }
    }
    
}
