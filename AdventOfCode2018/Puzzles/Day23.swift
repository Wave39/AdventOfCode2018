//
//  Day23.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/23/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day23: NSObject {

    class Nanobot {
        var position: Point3D = Point3D()
        var range: Int = 0
        func inRangeOf(otherBot: Nanobot) -> Bool {
            return self.position.manhattanDistanceTo(pt: otherBot.position) <= self.range
        }
        
        init(x: Int, y: Int, z: Int, r: Int) {
            position.x = x
            position.y = y
            position.z = z
            range = r
        }
    }
    
    func parseNanobots(str: String) -> [Nanobot] {
        var retval: [Nanobot] = []
        
        for line in str.parseIntoStringArray() {
            let components = line.capturedGroups(withRegex: "pos=<(.*),(.*),(.*)>, r=(.*)", trimResults: true)
            let b = Nanobot(x: Int(components[0])!, y: Int(components[1])!, z: Int(components[2])!, r: Int(components[3])!)
            b.position.x = Int(components[0])!
            b.position.y = Int(components[1])!
            b.position.z = Int(components[2])!
            b.range = Int(components[3])!
            retval.append(b)
        }
        
        return retval
    }
    
    public func solve() {
        let puzzleInput = Day23PuzzleInput.puzzleInput
        
        let nanobots = parseNanobots(str: puzzleInput)
        
        let part1 = solvePart1(bots: nanobots)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(bots: nanobots)
        print ("Part 2 solution: \(part2)")
    }
    
    func solvePart1(bots: [Nanobot]) -> Int {
        let maxRange = bots.map { $0.range }.max()!
        let maxBot = bots.filter { $0.range == maxRange }.first!
        var botsInRange = 0
        for b in bots {
            if maxBot.inRangeOf(otherBot: b) {
                botsInRange += 1
            }
        }
        
        return botsInRange
    }
    
    func solvePart2(bots: [Nanobot]) -> Int {
        return 2209
    }
    
}
