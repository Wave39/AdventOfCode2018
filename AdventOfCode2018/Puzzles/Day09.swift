//
//  Day09.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/9/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day09: NSObject {

    public func solve() {
        //let puzzleInput = Day09PuzzleInput.puzzleInput_test1
        let puzzleInput = Day09PuzzleInput.puzzleInput

        let part1 = playGame(game: puzzleInput[0])
        print ("Part 1 solution: \(part1)")
        let part2 = playGameBetter(game: puzzleInput[1])
        print ("Part 2 solution: \(part2)")
    }
    
    func playGameBetter(game: (Int, Int)) -> Int {
        // this method uses a doubly linked list instead of an integer array
        // the array inserts and deletes take far too long once the array reaches sufficient size
        
        class Node {
            var value: Int = 0
            var clockwise: Node?
            var counterclockwise: Node?
            var toString: String {
                return "\(self.value)"
            }
            
            var toStringChain: String {
                var retval = "[ \(self.value)"
                var next = self.clockwise!
                repeat {
                    retval = retval + " \(next.value)"
                    next = next.clockwise!
                } while next.value != self.value
                
                return retval + " ]"
            }
        }
        
        let playerCount = game.0
        let marbleCount = game.1

        let marbleLinkedList = Node()
        marbleLinkedList.value = 0
        marbleLinkedList.clockwise = marbleLinkedList
        marbleLinkedList.counterclockwise = marbleLinkedList
        
        var playerIndex = 0
        var scoringDictionary: Dictionary<Int, Int> = [:]
        var currentNode = marbleLinkedList
        for marble in 1...marbleCount {
            playerIndex += 1
            if playerIndex > playerCount {
                playerIndex = 1
            }
            
            if marble == 1 {
                let newNode = Node()
                newNode.value = 1
                newNode.clockwise = currentNode
                newNode.counterclockwise = currentNode
                currentNode.clockwise = newNode
                currentNode.counterclockwise = newNode
                currentNode = newNode
            } else if marble % 23 == 0 {
                if scoringDictionary[playerIndex] == nil {
                    scoringDictionary[playerIndex] = 0
                }
                
                var scoringNode = currentNode
                for _ in 1...7 {
                    scoringNode = scoringNode.counterclockwise!
                }
                
                scoringDictionary[playerIndex] = scoringDictionary[playerIndex]! + marble + scoringNode.value
                
                let previousNode = scoringNode.counterclockwise
                let nextNode = scoringNode.clockwise
                previousNode?.clockwise = nextNode
                nextNode?.counterclockwise = previousNode
                currentNode = nextNode!
            } else {
                let targetNode = currentNode.clockwise?.clockwise
                let previousToTargetNode = targetNode?.counterclockwise
                let newNode = Node()
                newNode.value = marble
                newNode.clockwise = targetNode
                newNode.counterclockwise = previousToTargetNode
                targetNode?.counterclockwise = newNode
                previousToTargetNode?.clockwise = newNode
                currentNode = newNode
            }
            
            //print("\(playerIndex) \(currentNode.toString) \(zeroNode.toStringChain)")
        }
        
        var retval = 0
        for (_, v) in scoringDictionary {
            if v > retval {
                retval = v
            }
        }
        
        return retval
    }
    
    func playGame(game: (Int, Int)) -> Int {
        let playerCount = game.0
        let marbleCount = game.1
        
        var marbleArray: [Int] = [ 0 ]
        var currentMarbleIndex = 0
        var playerIndex = 0
        var scoringDictionary: Dictionary<Int, Int> = [:]
        
        for marble in 1...marbleCount {
            playerIndex += 1
            if playerIndex > playerCount {
                playerIndex = 1
            }
            
            if marble == 1 {
                marbleArray.append(1)
                currentMarbleIndex = 1
            } else if marble % 23 == 0 {
                if scoringDictionary[playerIndex] == nil {
                    scoringDictionary[playerIndex] = 0
                }
                
                var scoringIndex = currentMarbleIndex - 7
                if scoringIndex < 0 {
                    scoringIndex += marbleArray.count
                }
                
                scoringDictionary[playerIndex] = scoringDictionary[playerIndex]! + marble + marbleArray[scoringIndex]
                marbleArray.remove(at: scoringIndex)
                currentMarbleIndex = scoringIndex
            } else {
                currentMarbleIndex += 2
                if currentMarbleIndex == marbleArray.count {
                    marbleArray.append(marble)
                    currentMarbleIndex = marbleArray.count - 1
                } else {
                    if currentMarbleIndex >= marbleArray.count {
                        currentMarbleIndex %= marbleArray.count
                    }
                    
                    marbleArray.insert(marble, at: currentMarbleIndex)
                }
            }
            
            //print("\(playerIndex) \(marbleArray[currentMarbleIndex]) \(marbleArray)")
        }
        
        var retval = 0
        for (_, v) in scoringDictionary {
            if v > retval {
                retval = v
            }
        }
        
        return retval
    }
    
}
