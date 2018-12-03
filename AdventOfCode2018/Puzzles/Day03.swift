//
//  Day03.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/3/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day03: NSObject {

    public func solve() {
        let puzzleInput = Day03PuzzleInput.puzzleInput
        let claims = Claim.parse(str: puzzleInput)
        
        let (part1, part2) = solveBothParts(claims: claims)
        print ("Part 1 solution: \(part1)")
        print ("Part 2 solution: \(part2)")
    }
    
    func solveBothParts(claims: [Claim]) -> (Int, Int) {
        var part1 = 0
        
        var fabric:[[Int]] = []
        let maxSize = 1000
        for _ in 0..<maxSize {
            var rowArray:[Int] = []
            for _ in 0..<maxSize {
                rowArray.append(0)
            }
            
            fabric.append(rowArray)
        }
        
        for claim in claims {
            for row in claim.topEdge..<(claim.topEdge + claim.height) {
                for col in claim.leftEdge..<(claim.leftEdge + claim.width) {
                    fabric[row][col] += 1
                }
            }
        }
        
        for row in 0..<maxSize {
            for col in 0..<maxSize {
                if fabric[row][col] >= 2 {
                    part1 += 1
                }
            }
        }
        
        var part2 = 0
        for claim in claims {
            var claimIsClean = true
            for row in claim.topEdge..<(claim.topEdge + claim.height) {
                for col in claim.leftEdge..<(claim.leftEdge + claim.width) {
                    if fabric[row][col] > 1 {
                        claimIsClean = false
                    }
                }
            }
            
            if claimIsClean {
                part2 = claim.idNumber
            }
        }
        
        return (part1, part2)
    }
}

class Claim {
    var idNumber: Int = 0
    var leftEdge: Int = 0
    var topEdge: Int = 0
    var width: Int = 0
    var height: Int = 0
    
    static func parse(str: String) -> [Claim] {
        var retval: [Claim] = []
        
        let arr = str.parseIntoStringArray()
        for line in arr {
            let items = line.parseIntoStringArray(separator: " ")
            let claim = Claim()
            claim.idNumber = items[0].replacingOccurrences(of: "#", with: "").toInt()
            let edgeArray = items[2].replacingOccurrences(of: ":", with: "").parseIntoStringArray(separator: ",")
            claim.leftEdge = edgeArray[0].toInt()
            claim.topEdge = edgeArray[1].toInt()
            let sizeArray = items[3].parseIntoStringArray(separator: "x")
            claim.width = sizeArray[0].toInt()
            claim.height = sizeArray[1].toInt()
            retval.append(claim)
        }
        
        return retval
    }
}
