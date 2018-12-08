//
//  Day08.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/8/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day08: NSObject {

    public func solve() {
        let puzzleInput = Day08PuzzleInput.puzzleInput
        
        let (part1, part2) = solveBothParts(str: puzzleInput)
        print ("Part 1 solution: \(part1)")
        print ("Part 2 solution: \(part2)")
    }

    var inputArray: [Int] = []
    var nodeIndex: Int = 0
    var part1MetadataArray: [Int] = []
    func getElement() -> Int {
        let retval = inputArray[nodeIndex];
        nodeIndex += 1
        return retval
    }
    
    func readNode() -> Node {
        let node = Node()
        
        node.childCount = getElement()
        let metadataCount = getElement()
        if node.childCount > 0 {
            for _ in 1...node.childCount {
                node.childNodes.append(readNode())
            }
        }
        
        for _ in 1...metadataCount {
            let element = Int(getElement())
            node.metadataArray.append(element)
            part1MetadataArray.append(element)
        }
        
        return node
    }
    
    func parseStringIntoArray(str: String) {
        inputArray = []
        let arr = str.parseIntoStringArray(separator: " ")
        for n in arr {
            inputArray.append(Int(n)!)
        }
    }
    
    func getPart2NodeValue(node: Node) -> Int {
        if node.childCount == 0 {
            return node.metadataArray.reduce(0, +)
        } else {
            var retval = 0
            for idx in node.metadataArray {
                if idx >= 1 && idx <= node.childCount {
                    retval += getPart2NodeValue(node: node.childNodes[idx - 1])
                }
            }

            return retval
        }
    }
    
    func solveBothParts(str: String) -> (Int, Int) {
        parseStringIntoArray(str: str)
        
        nodeIndex = 0
        part1MetadataArray = []
        let rootNode = readNode()
        let part1Answer = part1MetadataArray.reduce(0, +)
        let part2Answer = getPart2NodeValue(node: rootNode)
        
        return (part1Answer, part2Answer)
    }

}

class Node: NSObject {
    var childCount: Int = 0
    var childNodes: [Node] = []
    var metadataArray: [Int] = []
}
