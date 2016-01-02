//
//  Stadium.swift
//  HotSeats
//
//  Created by RPK on 12/21/15.
//  Copyright © 2015 rking. All rights reserved.
//

import Foundation
import CoreGraphics

class Stadium: NSObject {
    
    var moundCenter = CGPointZero
    var outerWall = Section(name: "", selectable: false)
    var homeDugout = Section(name: "", selectable: false)
    var visitorDugout = Section(name: "", selectable: false)
    var sections = [Section]()
}
