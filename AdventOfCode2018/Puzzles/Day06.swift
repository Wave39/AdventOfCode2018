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
        let puzzleInput = Day06PuzzleInput.puzzleInput

        let part1 = solvePart1(str: puzzleInput)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(str: puzzleInput)
        print ("Part 2 solution: \(part2)")
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
                for point in points {
                    let d = gl.manhattanDistanceTo(pt: point)
                    if d < gridLocation.closestDistance {
                        gridLocation.closestDistance = d
                        gridLocation.closestPointIndex = [ point ]
                    } else if d == gridLocation.closestDistance {
                        gridLocation.closestPointIndex.append(point)
                    }
                }
            }
        }
        
        // accumulate set of points closest to the edges of the bounding box
        // this was what I missed the first time through
        var closestPointSet: Set<Point2D> = []
        for row in 0...maxBounds.y {
            var pointsToRemove: [Point2D] = []
            
            let pt1 = Point2D(x: 0, y: row)
            var minimumDistance1 = Int.max
            for point in points {
                let d = pt1.manhattanDistanceTo(pt: point)
                if d < minimumDistance1 {
                    minimumDistance1 = d
                    pointsToRemove = [ point ]
                } else if d == minimumDistance1 {
                    pointsToRemove.append(point)
                }
            }
            
            let pt2 = Point2D(x: maxBounds.x, y: row)
            var minimumDistance2 = Int.max
            for point in points {
                let d = pt2.manhattanDistanceTo(pt: point)
                if d < minimumDistance2 {
                    minimumDistance2 = d
                    pointsToRemove = [ point ]
                } else if d == minimumDistance2 {
                    pointsToRemove.append(point)
                }
            }
            
            for point in pointsToRemove {
                closestPointSet.insert(point)
            }
        }
        
        for col in 0...maxBounds.x {
            var pointsToRemove: [Point2D] = []
            
            let pt1 = Point2D(x: col, y: 0)
            var minimumDistance1 = Int.max
            for point in points {
                let d = pt1.manhattanDistanceTo(pt: point)
                if d < minimumDistance1 {
                    minimumDistance1 = d
                    pointsToRemove = [ point ]
                } else if d == minimumDistance1 {
                    pointsToRemove.append(point)
                }
            }
            
            let pt2 = Point2D(x: col, y: maxBounds.y)
            var minimumDistance2 = Int.max
            for point in points {
                let d = pt2.manhattanDistanceTo(pt: point)
                if d < minimumDistance2 {
                    minimumDistance2 = d
                    pointsToRemove = [ point ]
                } else if d == minimumDistance2 {
                    pointsToRemove.append(point)
                }
            }
            
            for point in pointsToRemove {
                closestPointSet.insert(point)
            }
        }
        
        var largestArea = 0
        for point in points {
            if point.x > 0 && point.x < maxBounds.x && point.y > 0 && point.y < maxBounds.y && !closestPointSet.contains(point){
                var areaForThisPoint = 0
                for row in 0...maxBounds.y {
                    for col in 0...maxBounds.x {
                        let gridLocation = gridLocations[row][col]
                        if gridLocation.closestPointIndex.count == 1 && gridLocation.closestPointIndex[0] == point {
                            areaForThisPoint += 1
                        }
                    }
                }
                
                if areaForThisPoint > largestArea {
                    largestArea = areaForThisPoint
                }
            }
        }

        return largestArea
    }
    
    func solvePart2(str: String) -> Int {
        var retval = 0
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
                var totalDistance = 0
                let gl = Point2D(x: col, y: row)
                for point in points {
                    totalDistance += gl.manhattanDistanceTo(pt: point)
                }
                
                if totalDistance < 10000 {
                    retval += 1
                }
            }
        }
        
        return retval
    }
}

class GridLocation {
    var closestDistance = Int.max
    var closestPointIndex: [Point2D] = []
}
