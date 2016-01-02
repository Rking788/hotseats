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
        
        let evnt = Event(type: .Foul, date: NSDate(timeIntervalSinceNow:  86400))
        let evnt1 = Event(type: .Foul, date: NSDate(timeIntervalSinceNow: -86400))
        let evnt2 = Event(type: .Foul, date: NSDate(timeIntervalSinceNow: -259200))
        
        self.events.append(evnt1)
        self.events.append(evnt)
        self.events.append(evnt2)
        
        self.events.sortInPlace { (event1, event2) -> Bool in
            return event1.date.compare(event2.date) == .OrderedDescending
        }
        
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
    
    func getMostRecentEvent() -> Event? {
        if self.events.count == 0 {
            return nil
        }
        
        return self.events[0]
    }
}
