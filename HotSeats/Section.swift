//
//  Section.swift
//  HotSeats
//
//  Created by RPK on 12/21/15.
//  Copyright © 2015 rking. All rights reserved.
//

import Foundation

@objc(HSSection) class Section: NSObject {

    var coords = NSMutableArray()
    var name: String = ""
    
    init(name: String) {
        super.init()
        
        self.name = name
    }
    
    func addCoord(coord: CGPoint) {
        self.coords.addObject(NSValue(CGPoint: coord))
    }
    
    func getCoordAtIndex(index: NSInteger) -> CGPoint {
        //if self.coords.isEmpty || index >= self.coords.count {
        //    return CGPointMake(0, 0)
        //}
        
        return self.coords.objectAtIndex(index).CGPointValue
    }
}
