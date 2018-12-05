//
//  Day05.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/5/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day05: NSObject {

    public func solve() {
        let puzzleInput = Day05PuzzleInput.puzzleInput
        
        let part1 = solvePart1(polymer: puzzleInput)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(polymer: puzzleInput)
        print ("Part 2 solution: \(part2)")
    }
    
    func decomposePolymer(polymer: String) -> String {
        var str = polymer
        var removalFound: Bool
        var furthestAdvance = 0
        repeat {
            removalFound = false
            if furthestAdvance < (str.count - 1) {
                for i in furthestAdvance..<(str.count - 1) {
                    let c1 = String(str[i])
                    let c2 = String(str[i + 1])
                    if c1.uppercased() == c2.uppercased() && c1 != c2 {
                        removalFound = true
                        str.removeAtIndex(idx: i + 1)
                        str.removeAtIndex(idx: i)
                        furthestAdvance = i - 1
                        if furthestAdvance < 0 {
                            furthestAdvance = 0
                        }
                        
                        break
                    }
                }
            }
        } while removalFound
        
        return str
    }
    
    func decomposePolymerFaster(polymer: String) -> String {
        // this method is much faster but uses up more memory
        var str = polymer
        var lengthBeforeIteration: Int
        repeat {
            lengthBeforeIteration = str.count
            for c in "abcdefghijklmnopqrstuvwxyz" {
                let c1 = String(c) + String(c).uppercased()
                let c2 = String(c).uppercased() + String(c)
                str = str.replacingOccurrences(of: c1, with: "").replacingOccurrences(of: c2, with: "")
            }

        } while str.count != lengthBeforeIteration
        
        return str
    }
    
    func solvePart1(polymer: String) -> Int {
        return decomposePolymerFaster(polymer: polymer).count
    }

    func solvePart2(polymer: String) -> Int {
        var retval = Int.max
        for c in "abcdefghijklmnopqrstuvwxyz" {
            let c1 = String(c)
            let c2 = String(c).uppercased()
            let newPolymer = polymer.replacingOccurrences(of: c1, with: "").replacingOccurrences(of: c2, with: "")
            let newerPolymer = decomposePolymerFaster(polymer: newPolymer)
            if newerPolymer.count < retval {
                retval = newerPolymer.count
            }
        }
        
        return retval
    }
    
}
