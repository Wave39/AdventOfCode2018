//
//  Day15.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/15/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day15: NSObject {

    public class Unit : CustomStringConvertible {
        var unitType: Character = "?"
        var location: Point2D = Point2D()
        var attackPower: Int = 3
        var hitPoints: Int = 200
        var description: String {
            //return "[\(unitType) (\(location.x),\(location.y)) (\(attackPower), \(hitPoints))"
            return "\(unitType)(\(hitPoints))"
        }
    }
    
    var playfield: [[Character]] = []
    var units: [Unit] = []
    var pointToPointShortestPath: [[Point2D]] = []
    var shortestPathLength = 0
    
    public func solve() {
        let puzzleInput = Day15PuzzleInput.puzzleInput
        
        let part1 = solvePart1(str: puzzleInput)
        print ("Part 1 solution: \(part1)")
        //let part2 = solvePart2(str: puzzleInput)
        //print ("Part 2 solution: \(part2)")
    }
    
    func playfieldToString(_ playfield: [[Character]], _ units: [Unit]?) -> String {
        var playfieldCopy = playfield

        if units != nil {
            for unit in units! {
                playfieldCopy[unit.location.y][unit.location.x] = unit.unitType
            }
        }
        
        var retval = ""
        for line in playfieldCopy {
            retval += (String(line) + "\n")
        }
        
        return retval
    }
    
    func unitReadingOrder(left: Unit, right: Unit) -> Bool {
        if left.location.y != right.location.y {
            return left.location.y < right.location.y
        } else {
            return left.location.x < right.location.x
        }
    }

    func point2DReadingOrder(left: Point2D, right: Point2D) -> Bool {
        if left.y != right.y {
            return left.y < right.y
        } else {
            return left.x < right.x
        }
    }
    
    func solvePart1(str: String) -> Int {
        let lines = str.parseIntoStringArray()
        var x = 0, y = 0
        // parse the input into the playfield and the units
        for line in lines {
            var lineArray: [Character] = []
            x = 0
            for c in line {
                if c == "G" || c == "E" {
                    let unit = Unit()
                    unit.unitType = c
                    unit.location = Point2D(x: x, y: y)
                    units.append(unit)
                    lineArray.append(".")
                } else {
                    lineArray.append(c)
                }
                
                x += 1
            }
            
            playfield.append(lineArray)
            y += 1
        }
        
        print("Initial status")
        print(playfieldToString(playfield, units))
        print("Units: \(units.sorted(by: unitReadingOrder))")

        var roundsCompleted = 0
        var gameOver = false
        
        repeat {
            // sort units into reading order to begin iterating through turns
            units.sort(by: unitReadingOrder)
            
            for unit in units {
                if unit.hitPoints > 0 {
                    //print("Current unit: \(unit)")
                    let enemies = units.filter { $0.unitType != unit.unitType && $0.hitPoints > 0 }
                    //print("Enemies: \(enemies)")
                    if enemies.count == 0 {
                        // there are no enemies, thy game is over
                        gameOver = true
                        return roundsCompleted * units.filter { $0.hitPoints > 0 }.map {$0.hitPoints} .reduce(0, +)
                    }
                    
                    var targetLocations: [Point2D] = []
                    for enemy in enemies {
                        targetLocations.append(contentsOf: enemy.location.adjacentLocations())
                    }
                    
                    // only consider target locations that are floors (disregard walls)
                    targetLocations = targetLocations.filter { playfield[$0.y][$0.x] == "." }
                    
                    // remove target locations that have a unit there
                    for u in units {
                        if u.hitPoints > 0 && targetLocations.contains(u.location) {
                            targetLocations.removeAll { $0.x == u.location.x && $0.y == u.location.y }
                        }
                    }
                    
                    // see if there are any target locations already adjacent to the unit
                    var targetsInRange = enemies.filter {
                        $0.location.manhattanDistanceTo(pt: unit.location) == 1
                    }.sorted(by:unitReadingOrder)
                    
                    if targetsInRange.count == 0 && targetLocations.count == 0 {
                        continue
                    }
                    
                    if targetsInRange.count == 0 {
                        // move
                        var allPaths: [[Point2D]] = []
                        allPaths.append([ unit.location ])
                        
                        var leaveLoop = false
                        while !leaveLoop {
                            var newPaths: [[Point2D]] = []
                            for p in allPaths {
                                let steps = findAvailableSteps(location: p.last!)
                                for s in steps {
                                    var newP = p
                                    newP.append(s)
                                    newPaths.append(newP)
                                }
                            }
                            
                            allPaths = newPaths
                            if allPaths.count > 200 {
                                leaveLoop = true
                            }
                        }
                        
                        pointToPointShortestPath = []
                        shortestPathLength = Int.max
                        for target in targetLocations {
                            print("Looking for paths from \(unit.location) to \(target)")
                            findShortestPaths(previousPath: [], nextStep: unit.location, dest: target)
                        }
                        
                        //print("Shortest paths to a target: \(pointToPointShortestPath)")
                        var movePositionSet: Set<Point2D> = Set()
                        for p in pointToPointShortestPath {
                            movePositionSet.insert(p[1])
                        }
                        
                        if movePositionSet.count > 0 {
                            let mp = Array(movePositionSet.sorted(by: point2DReadingOrder))
                            //print("Move positions: \(mp)")
                            unit.location = mp[0]
                            //print(playfieldToString(playfield, units))
                            
                            // recalculate the targets in range as the unit has moved
                            targetsInRange = enemies.filter {
                                $0.location.manhattanDistanceTo(pt: unit.location) == 1
                                }.sorted(by:unitReadingOrder)
                        }
                    }
                    
                    // attack
                    //print("Targets in range: \(targetsInRange)")
                    if targetsInRange.count > 0 {
                        let minHitPoints = targetsInRange.map { $0.hitPoints }.min()
                        let attackTargets = targetsInRange.filter { $0.hitPoints == minHitPoints }.sorted(by: unitReadingOrder)
                        //print ("Targets to attack: \(attackTargets)")
                        attackTargets[0].hitPoints -= unit.attackPower
                    }
                }
                
            }
            
            roundsCompleted += 1
            units = units.filter { $0.hitPoints > 0 }
            print("After round: \(roundsCompleted)")
            print(playfieldToString(playfield, units))
            print("Units: \(units.sorted(by: unitReadingOrder))")
            print ("====================================================================================")

            // remove dead units
        } while !gameOver
        
        return -99
    }
    
    func findAvailableSteps(location: Point2D) -> [Point2D] {
        var retval: [Point2D] = []
        let up = Point2D(x: location.x, y: location.y - 1)
        if playfield[up.y][up.x] == "." && !(units.contains { $0.location.x == up.x && $0.location.y == up.y && $0.hitPoints > 0 }) {
            retval.append(up)
        }
        let left = Point2D(x: location.x - 1, y: location.y)
        if playfield[left.y][left.x] == "." && !(units.contains { $0.location.x == left.x && $0.location.y == left.y && $0.hitPoints > 0 }) {
            retval.append(left)
        }
        let right = Point2D(x: location.x + 1, y: location.y)
        if playfield[right.y][right.x] == "." && !(units.contains { $0.location.x == right.x && $0.location.y == right.y && $0.hitPoints > 0 }) {
            retval.append(right)
        }
        let down = Point2D(x: location.x, y: location.y + 1)
        if playfield[down.y][down.x] == "." && !(units.contains { $0.location.x == down.x && $0.location.y == down.y && $0.hitPoints > 0 }) {
            retval.append(down)
        }
    
        return retval
    }
    
    func findShortestPaths(previousPath: [Point2D], nextStep: Point2D, dest: Point2D) {
        var newPath = previousPath
        newPath.append(nextStep)

        if nextStep == dest {
            //print("Destination reached with path \(newPath)")
            if pointToPointShortestPath.count == 0 {
                pointToPointShortestPath = [ newPath ]
                shortestPathLength = newPath.count
                print("New shortest path length of \(shortestPathLength)")
            } else {
                if newPath.count < pointToPointShortestPath[0].count {
                    pointToPointShortestPath = [ newPath ]
                    shortestPathLength = newPath.count
                    print("New shortest path length of \(shortestPathLength)")
                } else if newPath.count == pointToPointShortestPath[0].count {
                    pointToPointShortestPath.append(newPath)
                    print("Appending another path of length \(shortestPathLength)")
                }
            }
            
            return
        }
        
        if newPath.count > shortestPathLength {
            return
        }
        
        //print("findShortestPaths from \(nextStep) to \(dest)")
        let nextSteps = findAvailableSteps(location: nextStep)
        //print("nextSteps: \(nextSteps)")
        for n in nextSteps {
            if !newPath.contains(n) {
                findShortestPaths(previousPath: newPath, nextStep: n, dest: dest)
            }
        }
    }
    
}
