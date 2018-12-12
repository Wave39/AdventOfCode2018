//
//  Day12.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/12/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day12: NSObject {

    public func solve() {
        let puzzleInput = Day12PuzzleInput.puzzleInput
        
        let part1 = solvePart1(puzzleInput: puzzleInput)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(puzzleInput: puzzleInput)
        print ("Part 2 solution: \(part2)")
    }

    func getPlantArray(inputString: String, arrayExtension: Int) -> [Bool] {
        var plantArray = Array(repeating: false, count: inputString.count + arrayExtension * 2)
        var idx = 0
        for c in inputString {
            if c == "#" {
                plantArray[idx + arrayExtension] = true
            }
            
            idx += 1
        }
        
        return plantArray
    }
    
    func getPlantGrowthSet(entries: String) -> Set<Int> {
        var plantGrowthSet: Set<Int> = Set()
        let arr = entries.parseIntoStringArray()
        for line in arr {
            if line.hasSuffix("#") {
                plantGrowthSet.insert((line[0] == "#" ? 16 : 0) + (line[1] == "#" ? 8 : 0) + (line[2] == "#" ? 4 : 0) + (line[3] == "#" ? 2 : 0) + (line[4] == "#" ? 1 : 0))
            }
        }
        
        return plantGrowthSet
    }
    
    func arrayToString(arr: [Bool]) -> String {
        var retval = ""
        for b in arr {
            retval += (b ? "#" : ".")
        }
        
        return retval
    }
    
    func solvePart1(puzzleInput: (String, String)) -> Int {
        let arrayExtension = 150
        var plantArray = getPlantArray(inputString: puzzleInput.0, arrayExtension: arrayExtension)
        let plantGrowthSet = getPlantGrowthSet(entries: puzzleInput.1)
        
        var generation = 0
        repeat {
            generation += 1
            var newPlantArray = Array(repeating: false, count: plantArray.count)
            for idx in 2..<plantArray.count - 2 {
                let b = (plantArray[idx - 2] ? 16 : 0) + (plantArray[idx - 1] ? 8 : 0) + (plantArray[idx] ? 4 : 0) + (plantArray[idx + 1] ? 2 : 0) + (plantArray[idx + 2] ? 1 : 0)
                newPlantArray[idx] = plantGrowthSet.contains(b)
            }
            
            plantArray = newPlantArray
        } while generation < 20
        
        var retval = 0
        for idx in 0..<plantArray.count {
            if plantArray[idx] {
                retval += (idx - arrayExtension)
            }
        }
        
        return retval
    }
    
    func solvePart2(puzzleInput: (String, String)) -> Int {
        // 50 billion iterations are too many to run efficiently, so I started to look for patterns or repeats
        // I noticed that at generation 100, the pattern of plants stayed at ###.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#
        // it just moved to the right by one pot number
        // so at generation 100, we can just move everything over by 50 billion - 100 pots, and calculate the total from there
        
        let arrayExtension = 1500
        var plantArray = getPlantArray(inputString: puzzleInput.0, arrayExtension: arrayExtension)
        let plantSet = getPlantGrowthSet(entries: puzzleInput.1)
        
        let maxGeneration = 50_000_000_000
        var generation = 0
        repeat {
            generation += 1
            var newPlantArray = Array(repeating: false, count: plantArray.count)
            for idx in 2..<plantArray.count - 2 {
                let b = (plantArray[idx - 2] ? 16 : 0) + (plantArray[idx - 1] ? 8 : 0) + (plantArray[idx] ? 4 : 0) + (plantArray[idx + 1] ? 2 : 0) + (plantArray[idx + 2] ? 1 : 0)
                newPlantArray[idx] = plantSet.contains(b)
            }
            
            plantArray = newPlantArray
            //let str = arrayToString(arr: plantArray)
            //print("\(generation) \(str)")
        } while generation < 100
        
        var retval = 0
        for idx in 0..<plantArray.count {
            if plantArray[idx] {
                retval += (idx - arrayExtension + (maxGeneration - 100))
            }
        }
        
        return retval
    }
    
}
