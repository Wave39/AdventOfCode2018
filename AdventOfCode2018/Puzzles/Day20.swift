//
//  Day20.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/20/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day20: NSObject {

    public func solve() {
        let puzzleInput = Day20PuzzleInput.puzzleInput

        let (part1, part2) = walkRoute(str: puzzleInput)
        print ("Part 1 solution: \(part1)")
        print ("Part 2 solution: \(part2)")
    }
    
    func walkRoute(str: String) -> (Int, Int) {
        var roomDictionary: Dictionary<Point2D, Int> = [:]
        var pt = Point2D(x: 0, y: 0)
        var stepCount = 0
        var ptStack: Stack<Point2D> = Stack()
        var stepCountStack: Stack<Int> = Stack()
        
        roomDictionary[pt] = stepCount
        for c in str {
            if c == "^" || c == "$" {
                // ignore starting and ending characters
            } else if c == "N" {
                stepCount += 1
                pt = Point2D(x: pt.x, y: pt.y - 1)
                if stepCount < roomDictionary[pt] ?? Int.max { roomDictionary[pt] = stepCount }
            } else if c == "S" {
                stepCount += 1
                pt = Point2D(x: pt.x, y: pt.y + 1)
                if stepCount < roomDictionary[pt] ?? Int.max { roomDictionary[pt] = stepCount }
            } else if c == "W" {
                stepCount += 1
                pt = Point2D(x: pt.x - 1, y: pt.y)
                if stepCount < roomDictionary[pt] ?? Int.max { roomDictionary[pt] = stepCount }
            } else if c == "E" {
                stepCount += 1
                pt = Point2D(x: pt.x + 1, y: pt.y)
                if stepCount < roomDictionary[pt] ?? Int.max { roomDictionary[pt] = stepCount }
            } else if c == "(" {
                ptStack.push(pt)
                stepCountStack.push(stepCount)
            } else if c == "|" {
                pt = ptStack.peek()!
                stepCount = stepCountStack.peek()!
            } else if c == ")" {
                let _ = ptStack.pop()
                let _ = stepCountStack.pop()
            } else {
                print("Unknown character: \(c)")
            }
        }
        
        let furthestRoom = roomDictionary.values.max()!
        let farAwayRooms = roomDictionary.values.filter { $0 >= 1000 }.count
        
        return (furthestRoom, farAwayRooms)
    }
    
}
