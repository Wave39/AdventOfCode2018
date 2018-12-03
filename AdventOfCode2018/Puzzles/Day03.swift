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
        let puzzleInput = Day03PuzzleInput.puzzleInput_test
        let claims = Claim.parse(str: puzzleInput)
        
        let part1 = solvePart1(claims: claims)
        print ("Part 1 solution: \(part1)")
        
        //let part2 = solvePart2(arr: array)
        //print ("Part 2 solution: \(part2)")
    }
    
    func solvePart1(claims: [Claim]) -> Int {
        var retval = 0
        
        return retval
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

