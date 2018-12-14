//
//  Day14.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/14/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day14: NSObject {

    public func solve() {
        let puzzleInput = Day14PuzzleInput.puzzleInput
        
        let solution = solveBothParts(puzzleInput: puzzleInput)
        print ("Part 1 solution: \(solution.0)")
        print ("Part 2 solution: \(solution.1)")
    }

    func solveBothParts(puzzleInput: Int) -> (String, Int) {
        var scoreboard = [3, 7]
        var elf1 = 0
        var elf2 = 1
        let numberOfScoreboardEntries = 21_000_000  // yeah, ok, this took some experimentation to figure out
        
        repeat {
            let newRecipe = scoreboard[elf1] + scoreboard[elf2]
            if newRecipe < 10 {
                scoreboard.append(newRecipe)
            } else {
                scoreboard.append(1)
                scoreboard.append(newRecipe % 10)
            }
            
            elf1 = (elf1 + scoreboard[elf1] + 1) % scoreboard.count
            elf2 = (elf2 + scoreboard[elf2] + 1) % scoreboard.count
        } while scoreboard.count < numberOfScoreboardEntries
        
        let arr = Array(scoreboard[puzzleInput..<(puzzleInput + 10)])
        let part1 = arr.map(String.init).joined()
        
        var part2 = -1
        for idx in 0..<scoreboard.count {
            if scoreboard[idx] == 1 && scoreboard[idx + 1] == 9 && scoreboard[idx + 2] == 0 && scoreboard[idx + 3] == 2 && scoreboard[idx + 4] == 2 && scoreboard[idx + 5] == 1 {
                part2 = idx
                break
            }
        }
        
        return (part1, part2)
    }
    
}
