//
//  Day06.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/6/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day06: NSObject {

    public func solve() {
        let puzzleInput = Day06PuzzleInput.puzzleInput_test
        
        let part1 = solvePart1(str: puzzleInput)
        print ("Part 1 solution: \(part1)")
        //let part2 = solvePart2(polymer: puzzleInput)
        //print ("Part 2 solution: \(part2)")
    }
    
    func parseIntoNormalizedCoordinates(str: String) -> [Point2D] {
        var retval: [Point2D] = []
        var minX = Int.max
        var minY = Int.max
        let arr = str.parseIntoStringArray()
        for s in arr {
            let coords = s.parseIntoStringArray(separator:",")
            let x = coords[0].toInt()
            let y = coords[1].toInt()
            let p = Point2D(x: x, y: y)
            retval.append(p)
            if x < minX {
                minX = x
            }
            
            if y < minY {
                minY = y
            }
        }
        
        for idx in 0..<retval.count {
            retval[idx] = Point2D(x: retval[idx].x - minX, y: retval[idx].y - minY)
        }
        
        return retval
    }
    
    func solvePart1(str: String) -> Int {
        let points = parseIntoNormalizedCoordinates(str: str)
        let maxBounds = Point2D.maximumBounds(arr: points)
        var gridLocations: [[GridLocation]] = []
        for _ in 0...maxBounds.y {
            var lineArray: [GridLocation] = []
            for _ in 0...maxBounds.x {
                lineArray.append(GridLocation())
            }
            
            gridLocations.append(lineArray)
        }
        
        for row in 0...maxBounds.y {
            for col in 0...maxBounds.x {
                let gridLocation = gridLocations[row][col]
                let gl = Point2D(x: col, y: row)
                let d = gl.manhattanDistanceTo(pt: points[0])
                print("Manhattan distance from \(gl) to \(points[0]) is \(d)")
            }
        }
        
        return 0
    }
}

class GridLocation {
    var closestDistance = Int.max
    var closestPoint = ""
}
