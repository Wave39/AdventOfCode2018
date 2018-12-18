//
//  Day17.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/17/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa
import Dispatch

extension Sequence {
    var tuple3: (Element, Element, Element)? {
        var iter = makeIterator()
        guard let first  = iter.next(),
            let second = iter.next(),
            let third  = iter.next()
            else { return nil }
        return (first, second, third)
    }
}

class Day17: NSObject {

    enum Area {
        case sand, clay, water, flowingWater
        var char: Character {
            switch self {
            case .sand: return "."
            case .clay: return "#"
            case .water: return "~"
            case .flowingWater: return "|"
            }
        }
        
        var isWater: Bool {
            return self == .water || self == .flowingWater
        }
    }
    
    struct Grid<Element> {
        var xRange: ClosedRange<Int>
        var yRange: ClosedRange<Int>
        var storage: [Element]
        
        init(repeating element: Element, x: ClosedRange<Int>, y: ClosedRange<Int>) {
            xRange = x
            yRange = y
            storage = [Element](repeating: element, count: xRange.count * yRange.count)
        }
        
        subscript(x x: Int, y y: Int) -> Element {
            get {
                precondition(xRange.contains(x) && yRange.contains(y))
                let xIndex = x - xRange.lowerBound
                let yIndex = y - yRange.lowerBound
                return storage[xRange.count * yIndex + xIndex]
            }
            set {
                precondition(xRange.contains(x) && yRange.contains(y))
                let xIndex = x - xRange.lowerBound
                let yIndex = y - yRange.lowerBound
                storage[xRange.count * yIndex + xIndex] = newValue
            }
        }
        
        func row(at y: Int) -> ArraySlice<Element> {
            precondition(yRange.contains(y))
            let yIndex = y - yRange.lowerBound
            return storage[(yIndex * xRange.count)..<((yIndex + 1) * xRange.count)]
        }
        
        var rows: LazyMapCollection<ClosedRange<Int>, ArraySlice<Element>> {
            return yRange.lazy.map { self.row(at: $0) }
        }
    }
    
    func aocD17(_ input: [(x: ClosedRange<Int>, y: ClosedRange<Int>)]) {
        let minX = input.lazy.map { $0.x.lowerBound }.min()! - 1
        let maxX = input.lazy.map { $0.x.upperBound }.max()! + 1
        let minY = input.lazy.map { $0.y.lowerBound }.min()!
        let maxY = input.lazy.map { $0.y.upperBound }.max()!
        let xbounds = minX...maxX
        let ybounds = minY...maxY
        var map = Grid(repeating: Area.sand, x: xbounds, y: ybounds)
        for (xrange, yrange) in input {
            for x in xrange {
                for y in yrange {
                    map[x: x, y: y] = .clay
                }
            }
        }
        func pourDown(x: Int, y: Int) -> Bool {
            var newY = y
            while map[x: x, y: newY] != .clay {
                map[x: x, y: newY] = .flowingWater
                newY += 1
                if !ybounds.contains(newY) {
                    return true
                }
            }
            repeat {
                // print(map.lazy.map({ String($0.lazy.map { $0.char }) }).joined(separator: "\n"))
                newY -= 1
            } while !pourSideways(x: x, y: newY) && newY > y
            return newY != y
        }
        func pourSideways(x: Int, y: Int) -> Bool {
            var lX = x
            var rX = x
            var spilled = false
            while map[x: lX, y: y] != .clay {
                let below = map[x: lX, y: y + 1]
                if below == .sand {
                    // print(map.lazy.map({ String($0.lazy.map { $0.char }) }).joined(separator: "\n"))
                    spilled = pourDown(x: lX, y: y) || spilled
                    break
                }
                else if below == .flowingWater {
                    spilled = true
                    break
                }
                map[x: lX, y: y] = .water
                lX -= 1
            }
            while map[x: rX, y: y] != .clay {
                let below = map[x: rX, y: y + 1]
                if below == .sand {
                    // print(map.lazy.map({ String($0.lazy.map { $0.char }) }).joined(separator: "\n"))
                    spilled = pourDown(x: rX, y: y) || spilled
                    break
                }
                else if below == .flowingWater {
                    spilled = true
                    break
                }
                map[x: rX, y: y] = .water
                rX += 1
            }
            if spilled {
                for x in lX...rX {
                    if map[x: x, y: y] == .water {
                        map[x: x, y: y] = .flowingWater
                    }
                }
            }
            return spilled
        }
        let start = DispatchTime.now()
        _ = pourDown(x: 500, y: minY)
        let end = DispatchTime.now()
        let allWater = map.storage.lazy.filter({ $0.isWater }).count
        let containedWater = map.storage.lazy.filter({ $0 == .water }).count
        let endCounting = DispatchTime.now()
        print(map.rows.lazy.map({ String($0.lazy.map { $0.char }) }).joined(separator: "\n"))
        print("""
            All water: \(allWater)
            Contained water: \(containedWater)
            Pour time: \(Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000)µs
            Counting time: \(Double(endCounting.uptimeNanoseconds - end.uptimeNanoseconds) / 1_000)µs
            """)
    }
    
    func solve() {
        let str = Day17PuzzleInput.puzzleInput
        
        let input = str.split(separator: "\n").map { line -> (x: ClosedRange<Int>, y: ClosedRange<Int>) in
            let (a, bstart, bend) = line.split(whereSeparator: { !"0123456789-".contains($0) }).map({ Int($0)! }).tuple3!
            if line.first == "x" {
                return (x: a...a, y: bstart...bend)
            }
            else {
                return (x: bstart...bend, y: a...a)
            }
        }
        
        aocD17(input)
    }
    
    // Once again, I am stumped while being so close to the solution
    // Maybe I will swing back around and revisit this later
    
//    var ground: [[Character]] = []
//    var springLocation: Point2D = Point2D()
//
//    class Vein {
//        var isVertical: Bool = false
//        var fixedCoordinate: Int = 0
//        var rangeLow: Int = 0
//        var rangeHigh: Int = 0
//        var isHorizontal: Bool {
//            return !isVertical
//        }
//    }
//
//    public func solve() {
//        //let puzzleInput = Day17PuzzleInput.puzzleInput_test
//        let puzzleInput = Day17PuzzleInput.puzzleInput
//
//        let lines = puzzleInput.parseIntoStringArray()
//        var clayVeins: [Vein] = []
//        for line in lines {
//            let arr = line.capturedGroups(withRegex: "(.*)=(.*), (.*)=(.*)\\.\\.(.*)", trimResults: true)
//            let v = Vein()
//            v.isVertical = (arr[0] == "x")
//            v.fixedCoordinate = Int(arr[1])!
//            v.rangeLow = Int(arr[3])!
//            v.rangeHigh = Int(arr[4])!
//            clayVeins.append(v)
//            if v.rangeLow >= v.rangeHigh {
//                print("Bad dates")
//            }
//        }
//
//        // find the minimum and maximum values
//        var minX = Int.max, minY = Int.max
//        var maxX = Int.min, maxY = Int.min
//        for vein in clayVeins {
//            if vein.isVertical {
//                minX = min(minX, vein.fixedCoordinate)
//                maxX = max(maxX, vein.fixedCoordinate)
//            } else {
//                minY = min(minY, vein.fixedCoordinate)
//                maxY = max(maxY, vein.fixedCoordinate)
//            }
//
//            if vein.isHorizontal {
//                minX = min(minX, vein.rangeLow, vein.rangeHigh)
//                maxX = max(maxX, vein.rangeLow, vein.rangeHigh)
//            } else {
//                minY = min(minY, vein.rangeLow, vein.rangeHigh)
//                maxY = max(maxY, vein.rangeLow, vein.rangeHigh)
//            }
//        }
//
//        // build the ground diagram
//        springLocation = Point2D(x: 500 - minX + 1, y: 0)
//        ground = Array(repeating: Array(repeating: ".", count: (maxX - minX + 3)), count: (maxY + 1))
//        ground[springLocation.y][springLocation.x] = "+"
//        for vein in clayVeins {
//            if vein.isVertical {
//                for y in vein.rangeLow...vein.rangeHigh {
//                    ground[y][vein.fixedCoordinate - minX + 1] = "#"
//                }
//            } else {
//                for x in vein.rangeLow...vein.rangeHigh {
//                    ground[vein.fixedCoordinate][x - minX + 1] = "#"
//                }
//            }
//        }
//
//        //print(groundToString(ground))
//
//        let part1 = solvePart1()
//        print ("Part 1 solution: \(part1)")
//        //let part2 = solvePart2(originalSamples: samples, testProgram: testProgram)
//        //print ("Part 2 solution: \(part2)")
//    }
//
//    func groundToString(_ ground: [[Character]]) -> String {
//        var retval = ""
//        for line in ground {
//            retval += (String(line) + "\n")
//        }
//
//        return retval
//    }
//
//    func locationConstraints(_ pt: Point2D) -> (Bool, Int, Bool, Int) {
//        var pt = pt
//        var leftPoint = 0, rightPoint = 0
//        var leftBounded = false, rightBounded = false
//
//        var keepLoopingLeft = true
//        while keepLoopingLeft {
//            pt = Point2D(x: pt.x - 1, y: pt.y)
//            if pt.x < 0 {
//                // the left boundary was reached
//                leftPoint = 0
//                leftBounded = false
//                keepLoopingLeft = false
//            } else if ground[pt.y][pt.x] == "#" {
//                // a wall was found, continue
//                leftPoint = pt.x + 1
//                leftBounded = true
//                keepLoopingLeft = false
//            } else if ground[pt.y][pt.x] == "." && ground[pt.y + 1][pt.x] == "." && ground[pt.y + 1][pt.x + 1] == "#" {
//                // a drop point was found
//                leftPoint = pt.x
//                leftBounded = false
//                keepLoopingLeft = false
//            }
//        }
//
//        var keepLoopingRight = true
//        while keepLoopingRight {
//            pt = Point2D(x: pt.x + 1, y: pt.y)
//            if pt.x >= ground[0].count {
//                // the right boundary was reached
//                rightPoint = pt.x - 1
//                rightBounded = false
//                keepLoopingRight = false
//            } else if ground[pt.y][pt.x] == "#" {
//                // a wall was found, continue
//                rightPoint = pt.x - 1
//                rightBounded = true
//                keepLoopingRight = false
//            } else if ground[pt.y][pt.x] == "." && ground[pt.y + 1][pt.x] == "." && pt.x > 0 && ground[pt.y + 1][pt.x - 1] == "#" {
//                // a drop point was found
//                rightPoint = pt.x
//                rightBounded = false
//                keepLoopingRight = false
//            }
//        }
//
//        return (leftBounded, leftPoint, rightBounded, rightPoint)
//    }
//
//    func processWaterFlow(_ originalPoint: Point2D) {
//        var pt = originalPoint
//        if pt.y >= ground.count {
//            // the water flow has reached the bottom of the area
//            return
//        }
//
//        var keepFlowing = true
//        var flowThroughPoints: [Point2D] = []
//        while keepFlowing {
//            if pt.y >= (ground.count - 1) {
//                // the water flow has reached the bottom of the area
//                flowThroughPoints = []
//                keepFlowing = false
//            } else {
//                let nextTile = ground[pt.y + 1][pt.x]
//                if nextTile == "#" {
//                    //print("Stop")
//                    //print("flowThroughPoints: \(flowThroughPoints)")
//                    keepFlowing = false
//                } else if nextTile == "." {
//                    pt = Point2D(x: pt.x, y: pt.y + 1)
//                    flowThroughPoints.append(pt)
//                    ground[pt.y][pt.x] = "|"
//                } else if nextTile == "~" {
//                    keepFlowing = false
////                    if ground[pt.y][pt.x - 1] == "." {
////                        ground[pt.y][pt.x - 1] = "="
////                        flowThroughPoints.append(Point2D(x: pt.x - 1, y: pt.y))
////                        //processWaterFlow(Point2D(x: pt.x - 1, y: pt.y))
////                    }
////
////                    if ground[pt.y][pt.x + 1] == "." {
////                        ground[pt.y][pt.x + 1] = "="
////                        flowThroughPoints.append(Point2D(x: pt.x + 1, y: pt.y))
////                        //processWaterFlow(Point2D(x: pt.x + 1, y: pt.y))
////                    }
//                } else if nextTile == "|" {
//                    keepFlowing = false
//                } else {
//                    print(groundToString(ground))
//                    print("Unknown situation for next tile: \(nextTile) below \(pt)")
//                }
//            }
//        }
//
//        for flowThroughPoint in flowThroughPoints.reversed() {
//            let constraint = locationConstraints(flowThroughPoint)
//            if constraint.0 && constraint.2 {
//                print("\(flowThroughPoint) is constrained to \(constraint)")
//                for x in constraint.1...constraint.3 {
//                    ground[flowThroughPoint.y][x] = "~"
//                }
//            } else if constraint.0 {
//                print("\(flowThroughPoint) is left constrained: \(constraint)")
//                for x in constraint.1...constraint.3 {
//                    ground[flowThroughPoint.y][x] = "|"
//                }
//
//                processWaterFlow(Point2D(x: constraint.3, y: flowThroughPoint.y))
//                //break
//            } else if constraint.2 {
//                print("\(flowThroughPoint) is right constrained: \(constraint)")
//                for x in constraint.1...constraint.3 {
//                    ground[flowThroughPoint.y][x] = "|"
//                }
//
//                processWaterFlow(Point2D(x: constraint.1, y: flowThroughPoint.y))
//                //break
//            } else {
//                print("\(flowThroughPoint) is not constrained: \(constraint)")
//                for x in constraint.1...constraint.3 {
//                    ground[flowThroughPoint.y][x] = "|"
//                }
//
//                processWaterFlow(Point2D(x: constraint.1, y: flowThroughPoint.y))
//                processWaterFlow(Point2D(x: constraint.3, y: flowThroughPoint.y))
//                //break
//            }
//        }
//
//        //print(groundToString(ground))
//    }
//
//    public func solvePart1() -> Int {
//        processWaterFlow(springLocation)
//        print("Final ground configuration:")
//        print(groundToString(ground))
//
//        let retval = ground.flatMap { $0 }.filter { $0 == "|" || $0 == "~" }.count
//
//        return retval
//
//    }

}
