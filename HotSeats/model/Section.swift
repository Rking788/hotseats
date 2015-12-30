//
//  Section.swift
//  HotSeats
//
//  Created by RPK on 12/21/15.
//  Copyright © 2015 rking. All rights reserved.
//

import Foundation
import CoreGraphics

class Section: NSObject {

    var coords = [CGPoint]()
    var name: String = ""
    
    init(name: String) {
        super.init()
        
        self.name = name
    }
    
    func addCoord(coord: CGPoint) {
        self.coords.append(coord)
    }
    
    func getCoordAtIndex(index: NSInteger) -> CGPoint {
        //return self.coords.objectAtIndex(index).CGPointValue
        return self.coords[index]
    }
}
