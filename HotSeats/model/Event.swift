//
//  Event.swift
//  HotSeats
//
//  Created by RPK on 12/30/15.
//  Copyright © 2015 RPK. All rights reserved.
//

import Foundation

enum EventType {
    case Homerun
    case Foul
}

// TODO: This should probably be an NSManagedObject and stored in CoreData

class Event: NSObject {

    var type: EventType
    var date: NSDate
    
    convenience override init() {
        self.init(type: .Foul)
    }
    
    init(type: EventType, date: NSDate = NSDate()) {
        self.date = date
        self.type = type
        
        super.init()
    }
    
    override var description: String {
        let idStr = NSString(format: "%x", ObjectIdentifier(self).uintValue)
        return "<\(self.dynamicType): ObjID=\(idStr)>: Date=\(self.formattedEventDate()), Type=\(self.type)>"
    }
    
    func formattedEventDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        
        return formatter.stringFromDate(self.date)
    }
}
