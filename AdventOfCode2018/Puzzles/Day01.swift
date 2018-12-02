//
//  Day01.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/1/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day01: NSObject {
    
    public func solve() {
        let part1 = solvePart1(str: Day01PuzzleInput.puzzleInput)
        print ("Part 1 solution: \(part1)")
        
        let part2 = solvePart2(str: Day01PuzzleInput.puzzleInput)
        print ("Part 2 solution: \(part2)")
    }
    
    public func solvePart1(str: String) -> Int {
        let arr = str.split(separator: "\n")
        
        var retval = 0
        for s in arr {
            retval += Int(String(s)) ?? 0
        }
        
        return retval
    }

    public func solvePart2(str: String) -> Int {
        let arr = str.split(separator: "\n")
        
        var freq = 0
        var valueDictionary: Dictionary<Int, Int> = [:]
        valueDictionary[0] = 0
        var ctr = 0
        
        while true {
            for s in arr {
                ctr += 1
                freq += Int(String(s)) ?? 0
                if valueDictionary[freq] != nil {
                    return freq
                } else {
                    valueDictionary[freq] = 1
                }
            }
        }
    }
}
