//
//  Day22.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/22/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day22: NSObject {

    public func solve() {
        let puzzleInput = Day22PuzzleInput.puzzleInput_test
        
        let part1 = solvePart1(puzzleInput: puzzleInput)
        print ("Part 1 solution: \(part1)")
        //let part2 = solvePart2(puzzleInput: puzzleInput)
        //print ("Part 2 solution: \(part2)")
    }
    
    public func solvePart1(puzzleInput: (Int, Int, Int)) -> Int {
        var retval = 0
        var map: [[Int]] = Array(repeating: (Array(repeating: 0, count: puzzleInput.1 + 1)), count: puzzleInput.2 + 1)
        var erosionMap: [[Int]] = Array(repeating: (Array(repeating: 0, count: puzzleInput.1 + 1)), count: puzzleInput.2 + 1)
        for y in 0...puzzleInput.2 {
            for x in 0...puzzleInput.1 {
                var idx: Int
                if (x == 0 && y == 0) || (x == puzzleInput.1 && y == puzzleInput.2) {
                    idx = 0
                } else if x == 0 {
                    idx = y * 48271
                } else if y == 0 {
                    idx = x * 16807
                } else {
                    idx = map[y][x - 1] * map[y - 1][x]
                }
                
                let erosion = (puzzleInput.0 + idx) % 20183
                map[y][x] = idx
                retval += (erosion % 3)
                
            }
        }
        
        return retval
    }

}
