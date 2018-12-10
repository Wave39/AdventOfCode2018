//
//  Day10.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/10/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day10: NSObject {

    public func solve() {
        let puzzleInput = Day10PuzzleInput.puzzleInput_test
        //let puzzleInput = Day10PuzzleInput.puzzleInput
        
        let part1 = solvePart1(pointsOfLight: puzzleInput)
        print ("Part 1 solution: \(part1)")
        //let part2 = playGameBetter(game: puzzleInput[1])
        //print ("Part 2 solution: \(part2)")
    }

    func parsePointsOfLight(pointsOfLight: String) -> [Particle2D] {
        var retval: [Particle2D] = []
        
        return retval
    }
    
    func solvePart1(pointsOfLight: String) -> String {
        var particles = parsePointsOfLight(pointsOfLight: pointsOfLight)
        
        return "Merry Christmas!"
    }
    
}
