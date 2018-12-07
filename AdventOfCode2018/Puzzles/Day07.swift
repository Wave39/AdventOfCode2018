//
//  Day07.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/7/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day07: NSObject {

    public func solve() {
        let puzzleInput = (Day07PuzzleInput.puzzleInput, 5, 60)

        let part1 = solvePart1(str: puzzleInput.0)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(str: puzzleInput.0, numberOfElves: puzzleInput.1, additionalSecondsPerStep: puzzleInput.2)
        print ("Part 2 solution: \(part2)")
    }

    func parseInstructionsIntoDictionary(str: String) -> Dictionary<String, String> {
        var retval: Dictionary<String, String> = [:]
        
        let arr = str.parseIntoStringArray()
        for line in arr {
            let words = line.parseIntoStringArray(separator: " ")
            let firstStep = words[1]
            let secondStep = words[7]
            if retval[secondStep] == nil {
                retval[secondStep] = firstStep
            } else {
                retval[secondStep] = retval[secondStep]! + firstStep
            }
            
            if retval[firstStep] == nil {
                retval[firstStep] = ""
            }
        }
        
        return retval
    }
    
    func findFirstAvailableStep(dict: Dictionary<String, String>) -> String {
        for k in dict.keys.sorted() {
            if dict[k]?.count == 0 {
                return k
            }
        }
        
        return ""
    }
    
    func removeStepFromDictionary(dict: Dictionary<String, String>, stepToRemove: String) -> Dictionary<String, String> {
        var retval: Dictionary<String, String> = [:]
        for (k, v) in dict {
            if k != stepToRemove {
                retval[k] = v.replacingOccurrences(of: stepToRemove, with: "")
            }
        }
        
        return retval
    }
    
    func solvePart1(str: String) -> String {
        var dict = parseInstructionsIntoDictionary(str: str)
        var retval = ""
        repeat {
            let available = findFirstAvailableStep(dict: dict)
            retval += available
            dict = removeStepFromDictionary(dict: dict, stepToRemove: available)
        } while dict.count > 0
            
        return retval
    }
    
    func completionTimeForTask(str: String, additionalSecondsPerStep: Int) -> Int {
        let asciiTime = str.asciiValue - "A".asciiValue + 1
        return Int(asciiTime) + additionalSecondsPerStep
    }
    
    func findAvailableSteps(dict: Dictionary<String, String>) -> [String] {
        var retval: [String] = []
        for k in dict.keys.sorted() {
            if dict[k]?.count == 0 {
                retval.append(k)
            }
        }
        
        return retval
    }
    
    func findAvailableElf(elves: Array<(String, Int)>) -> Int {
        for idx in 0..<elves.count {
            if elves[idx].0 == "" {
                return idx
            }
        }
        
        return -1
    }
    
    func isStepInProgress(elves: Array<(String, Int)>, step: String) -> Bool {
        for elf in elves {
            if elf.0 == step {
                return true
            }
        }
        
        return false
    }
    
    func solvePart2(str: String, numberOfElves: Int, additionalSecondsPerStep: Int) -> Int {
        var second = 0
        var dict = parseInstructionsIntoDictionary(str: str)
        var elves: Array<(String, Int)> = []
        for _ in 1...numberOfElves {
            elves.append(("", 0))
        }
        
        repeat {
            // find available tasks and assign to available elves
            let availableSteps = findAvailableSteps(dict: dict)
            for step in availableSteps {
                let availableElf = findAvailableElf(elves: elves)
                if availableElf != -1 && !isStepInProgress(elves: elves, step: step) {
                    elves[availableElf] = (step, completionTimeForTask(str: step, additionalSecondsPerStep: additionalSecondsPerStep))
                }
            }
            
            second += 1
            
            // subtract a second from each elf's work
            for idx in 0..<elves.count {
                if elves[idx].0.count > 0 {
                    elves[idx].1 = elves[idx].1 - 1
                }
            }

            // check for elves that are done
            for idx in 0..<elves.count {
                if elves[idx].0.count > 0 && elves[idx].1 == 0 {
                    dict = removeStepFromDictionary(dict: dict, stepToRemove: elves[idx].0)
                    elves[idx] = ("", 0)
                }
            }
        } while dict.count > 0
        
        return second
    }
}
