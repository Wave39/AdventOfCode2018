//
//  Day17.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/17/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day17: NSObject {

    var ground: [[Character]] = []
    var springLocation: Point2D = Point2D()
    
    class Vein {
        var isVertical: Bool = false
        var fixedCoordinate: Int = 0
        var rangeLow: Int = 0
        var rangeHigh: Int = 0
        var isHorizontal: Bool {
            return !isVertical
        }
    }
    
    public func solve() {
        //let puzzleInput = Day17PuzzleInput.puzzleInput_test
        let puzzleInput = Day17PuzzleInput.puzzleInput

        let lines = puzzleInput.parseIntoStringArray()
        var clayVeins: [Vein] = []
        for line in lines {
            let arr = line.capturedGroups(withRegex: "(.*)=(.*), (.*)=(.*)\\.\\.(.*)", trimResults: true)
            let v = Vein()
            v.isVertical = (arr[0] == "x")
            v.fixedCoordinate = Int(arr[1])!
            v.rangeLow = Int(arr[3])!
            v.rangeHigh = Int(arr[4])!
            clayVeins.append(v)
            if v.rangeLow >= v.rangeHigh {
                print("Bad dates")
            }
        }

        // find the minimum and maximum values
        var minX = Int.max, minY = Int.max
        var maxX = Int.min, maxY = Int.min
        for vein in clayVeins {
            if vein.isVertical {
                minX = min(minX, vein.fixedCoordinate)
                maxX = max(maxX, vein.fixedCoordinate)
            } else {
                minY = min(minY, vein.fixedCoordinate)
                maxY = max(maxY, vein.fixedCoordinate)
            }
            
            if vein.isHorizontal {
                minX = min(minX, vein.rangeLow, vein.rangeHigh)
                maxX = max(maxX, vein.rangeLow, vein.rangeHigh)
            } else {
                minY = min(minY, vein.rangeLow, vein.rangeHigh)
                maxY = max(maxY, vein.rangeLow, vein.rangeHigh)
            }
        }
        
        // build the ground diagram
        springLocation = Point2D(x: 500 - minX + 1, y: 0)
        ground = Array(repeating: Array(repeating: ".", count: (maxX - minX + 3)), count: (maxY + 1))
        ground[springLocation.y][springLocation.x] = "+"
        for vein in clayVeins {
            if vein.isVertical {
                for y in vein.rangeLow...vein.rangeHigh {
                    ground[y][vein.fixedCoordinate - minX + 1] = "#"
                }
            } else {
                for x in vein.rangeLow...vein.rangeHigh {
                    ground[vein.fixedCoordinate][x - minX + 1] = "#"
                }
            }
        }

        print(groundToString(ground))
        
        let part1 = solvePart1()
        print ("Part 1 solution: \(part1)")
        //let part2 = solvePart2(originalSamples: samples, testProgram: testProgram)
        //print ("Part 2 solution: \(part2)")
    }
    
    func groundToString(_ ground: [[Character]]) -> String {
        var retval = ""
        for line in ground {
            retval += (String(line) + "\n")
        }
        
        return retval
    }
    
    func locationConstraints(_ pt: Point2D) -> (Bool, Int, Bool, Int) {
        var pt = pt
        var leftPoint = 0, rightPoint = 0
        var leftBounded = false, rightBounded = false

        var keepLoopingLeft = true
        while keepLoopingLeft {
            pt = Point2D(x: pt.x - 1, y: pt.y)
            if ground[pt.y][pt.x] == "#" {
                // a wall was found, continue
                leftPoint = pt.x + 1
                leftBounded = true
                keepLoopingLeft = false
            } else if ground[pt.y][pt.x] == "." && ground[pt.y + 1][pt.x] == "." {
                // a drop point was found
                leftPoint = pt.x
                leftBounded = false
                keepLoopingLeft = false
            }
        }
        
        var keepLoopingRight = true
        while keepLoopingRight {
            pt = Point2D(x: pt.x + 1, y: pt.y)
            if ground[pt.y][pt.x] == "#" {
                // a wall was found, continue
                rightPoint = pt.x - 1
                rightBounded = true
                keepLoopingRight = false
            } else if ground[pt.y][pt.x] == "." && ground[pt.y + 1][pt.x] == "." {
                // a drop point was found
                rightPoint = pt.x
                rightBounded = false
                keepLoopingRight = false
            }
        }
        
        return (leftBounded, leftPoint, rightBounded, rightPoint)
    }
    
    func processWaterFlow(_ originalPoint: Point2D) {
        var pt = originalPoint
        if pt.y >= ground.count {
            // the water flow has reached the bottom of the area
            return
        }
        
        var keepFlowing = true
        var flowThroughPoints: [Point2D] = []
        while keepFlowing {
            if pt.y >= (ground.count - 1) {
                // the water flow has reached the bottom of the area
                flowThroughPoints = []
                keepFlowing = false
            } else {
                let nextTile = ground[pt.y + 1][pt.x]
                if nextTile == "#" {
                    print("Stop")
                    print("flowThroughPoints: \(flowThroughPoints)")
                    keepFlowing = false
                } else if nextTile == "." {
                    pt = Point2D(x: pt.x, y: pt.y + 1)
                    flowThroughPoints.append(pt)
                    ground[pt.y][pt.x] = "|"
                } else {
                    print("Unknown situation for next tile: \(nextTile)")
                }
            }
        }
        
        for flowThroughPoint in flowThroughPoints.reversed() {
            let constraint = locationConstraints(flowThroughPoint)
            if constraint.0 && constraint.2 {
                print("\(flowThroughPoint) is constrained to \(constraint)")
                for x in constraint.1...constraint.3 {
                    ground[flowThroughPoint.y][x] = "~"
                }
            } else if constraint.0 {
                print("\(flowThroughPoint) is left constrained: \(constraint)")
                for x in constraint.1...constraint.3 {
                    ground[flowThroughPoint.y][x] = "|"
                }
                
                processWaterFlow(Point2D(x: constraint.3, y: flowThroughPoint.y))
                break
            } else if constraint.2 {
                print("\(flowThroughPoint) is right constrained: \(constraint)")
                for x in constraint.1...constraint.3 {
                    ground[flowThroughPoint.y][x] = "|"
                }

                processWaterFlow(Point2D(x: constraint.1, y: flowThroughPoint.y))
                break
            } else {
                print("\(flowThroughPoint) is not constrained: \(constraint)")
                for x in constraint.1...constraint.3 {
                    ground[flowThroughPoint.y][x] = "|"
                }
                
                processWaterFlow(Point2D(x: constraint.1, y: flowThroughPoint.y))
                processWaterFlow(Point2D(x: constraint.3, y: flowThroughPoint.y))
                break
            }
        }
        
        print(groundToString(ground))
    }
    
    public func solvePart1() -> Int {
        processWaterFlow(springLocation)
        
        let retval = ground.flatMap { $0 }.filter { $0 == "|" || $0 == "~" }.count
        
        return retval
        
    }

}
