//
//  Point2D.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/6/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

import Foundation

struct Point2D: Hashable {
    var x : Int = 0
    var y : Int = 0
    
    var hashValue: Int {
        return "(\(x),\(y))".hashValue
    }
    
    var description: String {
        return "(\(x),\(y))"
    }
    
    static func == (lhs: Point2D, rhs: Point2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func maximumBounds(arr: [Point2D]) -> Point2D {
        var retval = Point2D(x: 0, y: 0)
        for p in arr {
            if p.x > retval.x {
                retval.x = p.x
            }
            
            if p.y > retval.y {
                retval.y = p.y
            }
        }
        
        return retval
    }
    
    func manhattanDistanceTo(pt: Point2D) -> Int {
        return abs(self.x - pt.x) + abs(self.y - pt.y)
    }
}
