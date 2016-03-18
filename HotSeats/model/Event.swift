//
//  Event.swift
//  HotSeats
//
//  Created by RPK on 12/30/15.
//  Copyright © 2015 RPK. All rights reserved.
//

import Foundation

enum EventType: String {
    case Homerun
    case Foul
}

// TODO: This should probably be an NSManagedObject and stored in CoreData

class Event: NSObject {

    var type: EventType
    var date: NSDate
    
    // TODO: Eventually this relationship will be handled by CoreData...
    //var stadium: Stadium!
    
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
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return formatter.stringFromDate(self.date)
    }
    
    func toDictionary() -> [String : AnyObject] {
        return [
            "type": self.type.rawValue,
            "date": self.formattedEventDate(),
            "stadium": [
                // FIXME: Obviously not right, fix it
                "name": "Fenway Park"
            ]
        ]
    }
}
