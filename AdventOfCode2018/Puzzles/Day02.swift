//
//  Day02.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/2/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day02: NSObject {

    public func solve() {
        let puzzleInput = Day02PuzzleInput.puzzleInput
        let array = puzzleInput.parseIntoStringArray()
        
        let part1 = solvePart1(arr: array)
        print ("Part 1 solution: \(part1)")
        
        let part2 = solvePart2(arr: array)
        print ("Part 2 solution: \(part2)")
    }

    func solvePart1(arr: [String]) -> Int {
        var counterOfTwos = 0
        var counterOfThrees = 0
        for s in arr {
            if s.hasConsecutiveCharacters(num: 2) {
                counterOfTwos += 1
            }
            
            if s.hasConsecutiveCharacters(num: 3) {
                counterOfThrees += 1
            }
        }
        
        return counterOfTwos * counterOfThrees
    }
    
    func solvePart2(arr: [String]) -> String {
        var minDifference = Int.max
        var minI = 0
        var minJ = 0
        
        for i in 0..<(arr.count - 1) {
            for j in (i + 1)..<arr.count {
                let diff = arr[i].charactersDifferentFrom(str: arr[j])
                if diff < minDifference {
                    minDifference = diff
                    minI = i
                    minJ = j
                }
            }
        }
        
        return arr[minI].commonCharactersWith(str: arr[minJ])
    }
    
}
