//
//  Particle2D.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/10/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

struct Particle2D {

    var x : Int = 0
    var y : Int = 0
    var deltaX: Int = 0
    var deltaY: Int = 0
    
    var hashValue: Int {
        return description.hashValue
    }
    
    var description: String {
        return "(\(x),\(y)) -> (\(deltaX),\(deltaY))"
    }
    
    static func == (lhs: Particle2D, rhs: Particle2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.deltaX == rhs.deltaX && lhs.deltaY == rhs.deltaY
    }

}
