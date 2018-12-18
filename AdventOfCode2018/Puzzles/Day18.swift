//
//  Day18.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/18/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day18: NSObject {

    enum Acre : Character {
        case Open = "."
        case Trees = "|"
        case Lumberyard = "#"
    }
    
    typealias Forest = [[Acre]]
    
    func forestToString(_ forest: Forest) -> String {
        var retval = ""
        for line in forest {
            for c in line {
                retval += String(c.rawValue)
            }
            
            retval += "\n"
        }
        
        return retval
    }
    
    public func solve() {
        let puzzleInput = Day18PuzzleInput.puzzleInput
        
        var forest: Forest = []
        let arr = puzzleInput.parseIntoStringArray()
        for line in arr {
            var forestLine: [Acre] = []
            for c in line {
                forestLine.append(Acre(rawValue: c)!)
            }
            
            forest.append(forestLine)
        }
        
        let part1 = solvePart1(forest: forest)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(forest: forest)
        print ("Part 2 solution: \(part2)")
    }
    
    func getSurroundingAcres(forest: Forest, x: Int, y: Int) -> [Acre] {
        var retval: [Acre] = []
        for y1 in (y - 1)...(y + 1) {
            for x1 in (x - 1) ... (x + 1) {
                if y1 >= 0 && y1 < forest.count && x1 >= 0 && x1 < forest[0].count && !(x1 == x && y1 == y) {
                    retval.append(forest[y1][x1])
                }
            }
        }
        
        return retval
    }
    
    func processForest(_ forest: Forest) -> Forest {
        var retval = forest
        for y in 0..<forest.count {
            for x in 0..<forest[0].count {
                let surroundingAcres = getSurroundingAcres(forest: forest, x: x, y: y)
                if forest[y][x] == .Open {
                    if (surroundingAcres.filter { $0 == .Trees }.count) >= 3 {
                        retval[y][x] = .Trees
                    } else {
                        retval[y][x] = .Open
                    }
                } else if forest[y][x] == .Trees {
                    if (surroundingAcres.filter { $0 == .Lumberyard }.count) >= 3 {
                        retval[y][x] = .Lumberyard
                    } else {
                        retval[y][x] = .Trees
                    }
                } else {
                    if (surroundingAcres.filter { $0 == .Lumberyard }.count) >= 1 && (surroundingAcres.filter { $0 == .Trees }.count) >= 1 {
                        retval[y][x] = .Lumberyard
                    } else {
                        retval[y][x] = .Open
                    }
                }
            }
        }
        
        return retval
    }
    
    public func solvePart1(forest: Forest) -> Int {
        var forest = forest
        var minutesElapsed = 0

        repeat {
            forest = processForest(forest)
            minutesElapsed += 1
        } while minutesElapsed < 10
        
        let woods = forest.flatMap { $0 }.filter { $0 == .Trees }.count
        let lumberyards = forest.flatMap { $0 }.filter { $0 == .Lumberyard }.count

        return woods * lumberyards
    }

    public func solvePart2(forest: Forest) -> Int {
        var forest = forest
        var foundDuplicate = false
        var minutesElapsed = 0
        var forestArray: [String] = []
        var advance = 0
        
        // find where the output repeats and forms a loop
        repeat {
            forest = processForest(forest)
            minutesElapsed += 1
            let s = forestToString(forest)
            if forestArray.contains(s) {
                foundDuplicate = true
                advance = minutesElapsed - 1 - forestArray.firstIndex(of: s)!
            } else {
                forestArray.append(s)
            }
        } while !foundDuplicate
        
        // advance to the last step of the loop before the end condition
        while minutesElapsed < 1_000_000_000 {
            minutesElapsed += advance
        }
        
        minutesElapsed -= advance
        
        repeat {
            forest = processForest(forest)
            minutesElapsed += 1
        } while minutesElapsed < 1_000_000_000

        let woods = forest.flatMap { $0 }.filter { $0 == .Trees }.count
        let lumberyards = forest.flatMap { $0 }.filter { $0 == .Lumberyard }.count
        
        return woods * lumberyards
    }
    
}
