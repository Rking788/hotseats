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

    // What info would users want? 
    // - Name
    // - "Heat Index"
    // - Number of "events"
    // - Date of last event(?)
    
    var coords = [CGPoint]()
    let name: String
    var events = [Event]()
    var selectable = true
    
    init(name: String) {
        self.name = name
        
        super.init()
    }
    
    convenience init(name: String, selectable: Bool) {
        self.init(name: name)
        self.selectable = selectable
    }
    
    func addCoord(coord: CGPoint) {
        self.coords.append(coord)
    }
    
    func getCoordAtIndex(index: NSInteger) -> CGPoint {
        return self.coords[index]
    }
}
