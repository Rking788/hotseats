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

class Event: NSObject {

    let type: EventType
    let date: NSDate
    
    convenience override init() {
        self.init(type: .Foul)
    }
    
    init(type: EventType, date: NSDate = NSDate()) {
        self.date = date
        self.type = type
        
        super.init()
    }
}
