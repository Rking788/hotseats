//
//  Stadium.swift
//  HotSeats
//
//  Created by RPK on 12/21/15.
//  Copyright © 2015 rking. All rights reserved.
//

import Foundation

@objc(HSStadium) class Stadium: NSObject {
    
    var moundCenter = CGPointZero
    var outerWall = Section(name: "")
    var homeDugout = Section(name: "")
    var visitorDugout = Section(name: "")
    let sections = NSMutableArray()
}
