//
//  Section.swift
//  HotSeats
//
//  Created by RPK on 12/21/15.
//  Copyright © 2015 rking. All rights reserved.
//

import Foundation
import CoreGraphics

// TODO: This should probably be an NSManagedObject...? 
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
        
        super.init()
        
        self.sortEvents()
    }
    
    convenience init(name: String, selectable: Bool) {
        self.init(name: name)
        self.selectable = selectable
    }
    
    override var description: String {
        let idStr = NSString(format: "%x", ObjectIdentifier(self).uintValue)
        return "<\(self.dynamicType): ObjID=\(idStr)>: Name=\(self.name), EventCount=\(self.events.count), Selectable=\(self.selectable)>"
    }
    
    func addCoord(coord: CGPoint) {
        self.coords.append(coord)
    }
    
    func getCoordAtIndex(index: NSInteger) -> CGPoint {
        return self.coords[index]
    }
    
    func addEvent(evt: Event) {
        self.events.append(evt)
        
        self.sortEvents()
    }
    
    func sortEvents() {
        self.events.sortInPlace { (event1, event2) -> Bool in
            return event1.date.compare(event2.date) == .OrderedDescending
        }
    }
    
    func getMostRecentEvent() -> Event? {
        if self.events.count == 0 {
            return nil
        }
        
        return self.events[0]
    }
}
