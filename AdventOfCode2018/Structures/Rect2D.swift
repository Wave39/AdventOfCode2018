//
//  Rect2D.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/10/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

struct Rect2D: Hashable {
    var x1 : Int = 0
    var y1 : Int = 0
    var x2: Int = 0
    var y2: Int = 0
    
    var hashValue: Int {
        return description.hashValue
    }
    
    var description: String {
        return "(\(x1),\(y1)) -> (\(x2),\(y2))"
    }
    
    static func == (lhs: Rect2D, rhs: Rect2D) -> Bool {
        return lhs.x1 == rhs.x1 && lhs.y1 == rhs.y1 && lhs.x2 == rhs.x2 && lhs.y2 == rhs.y2
    }
    

}
