//
//  Day13.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/13/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day13: NSObject {
    
    enum TrackType {
        case NoTrack
        case StraightHorizontal
        case StraightVertical
        case CornerSlash
        case CornerBackslash
        case Intersection
    }
    
    enum TravelDirection: Int {
        case Up = 0
        case Right
        case Down
        case Left
        case Straight
        func turnLeft() -> TravelDirection {
            if self == .Up {
                return .Left
            } else if self == .Right {
                return .Up
            } else if self == .Down {
                return .Right
            } else if self == .Left {
                return .Down
            }
            
            return .Straight
        }

        func turnRight() -> TravelDirection {
            if self == .Up {
                return .Right
            } else if self == .Right {
                return .Down
            } else if self == .Down {
                return .Left
            } else if self == .Left {
                return .Up
            }
            
            return .Straight
        }
    }
    
    class Cart {
        var location: Point2D = Point2D()
        var travelDirection: TravelDirection = .Up
        var nextTurnDirection: TravelDirection = .Left
        var ghost: Bool = false
    }
    
    public func solve() {
        let puzzleInput = Day13PuzzleInput.puzzleInput
        
        let (part1, part2) = solveBothParts(puzzleInput: puzzleInput)
        print ("Part 1 solution: \(part1)")
        print ("Part 2 solution: \(part2)")
    }
    
    func trackGridToString(trackGrid: [[TrackType]], carts: [Cart]) -> String {
        var characterArray: [[String]] = []
        for line in trackGrid {
            var characterLine: [String] = []
            for c in line {
                var s = "?"
                if c == .NoTrack {
                    s = " "
                } else if c == .StraightHorizontal {
                    s = "-"
                } else if c == .StraightVertical {
                    s = "|"
                } else if c == .CornerBackslash {
                    s = "\\"
                } else if c == .CornerSlash {
                    s = "/"
                } else if c == .Intersection {
                    s = "+"
                }
                
                characterLine.append(s)
            }
            
            characterArray.append(characterLine)
        }
        
        for cart in carts {
            var c = "?"
            if cart.travelDirection == .Up {
                c = "^"
            } else if cart.travelDirection == .Right {
                c = ">"
            } else if cart.travelDirection == .Down {
                c = "v"
            } else if cart.travelDirection == .Left {
                c = "<"
            }
            
            characterArray[cart.location.y][cart.location.x] = c
        }
        
        var retval = ""
        for line in characterArray {
            retval += (line.joined() + "\n")
        }
        
        return retval
    }
    
    func solveBothParts(puzzleInput: String) -> ((Int, Int), (Int, Int)) {
        let lines = puzzleInput.parseIntoStringArray()
        var currentX = 0, currentY = 0
        var trackGrid: [[TrackType]] = []
        var carts: [Cart] = []
        for line in lines {
            var lineArray: [TrackType] = []
            currentX = 0
            for c in line {
                var t = TrackType.NoTrack
                if c == "-" {
                    t = .StraightHorizontal
                } else if c == "|" {
                    t = .StraightVertical
                } else if c == "/" {
                    t = .CornerSlash
                } else if c == "`" {
                    t = .CornerBackslash
                } else if c == "+" {
                    t = .Intersection
                } else if c == ">" {
                    t = .StraightHorizontal
                    let cart = Cart()
                    cart.location.x = currentX
                    cart.location.y = currentY
                    cart.travelDirection = .Right
                    carts.append(cart)
                } else if c == "<" {
                    t = .StraightHorizontal
                    let cart = Cart()
                    cart.location.x = currentX
                    cart.location.y = currentY
                    cart.travelDirection = .Left
                    carts.append(cart)
                } else if c == "^" {
                    t = .StraightVertical
                    let cart = Cart()
                    cart.location.x = currentX
                    cart.location.y = currentY
                    cart.travelDirection = .Up
                    carts.append(cart)
                } else if c == "v" {
                    t = .StraightVertical
                    let cart = Cart()
                    cart.location.x = currentX
                    cart.location.y = currentY
                    cart.travelDirection = .Down
                    carts.append(cart)
                } else if c == "." {
                    // nothing to do
                } else {
                    print("Unknown entry in input: \(c)")
                }
                
                lineArray.append(t)
                currentX += 1
            }
            
            trackGrid.append(lineArray)
            currentY += 1
        }
        
        //print(trackGridToString(trackGrid: trackGrid, carts: carts))
        
        var tickCount = 0
        var firstCollisionX = -1, firstCollisionY = -1
        repeat {
            // sort the carts
            carts.sort {
                if $0.location.y != $1.location.y {
                    return $0.location.y < $1.location.y
                } else {
                    return $0.location.x < $1.location.x
                }
            }
            
            for cart in carts {
                if !cart.ghost {
                    // move the cart
                    if cart.travelDirection == .Up {
                        cart.location.y -= 1
                    } else if cart.travelDirection == .Right {
                        cart.location.x += 1
                    } else if cart.travelDirection == .Down {
                        cart.location.y += 1
                    } else if cart.travelDirection == .Left {
                        cart.location.x -= 1
                    }
                    
                    // check for collisions
                    let collisionCheck = carts.filter { $0.location.x == cart.location.x && $0.location.y == cart.location.y }
                    if collisionCheck.count != 1 {
                        for c2 in carts {
                            if c2.location.x == cart.location.x && c2.location.y == cart.location.y {
                                c2.ghost = true
                            }
                        }
                        
                        if firstCollisionX == -1 {
                            firstCollisionX = cart.location.x
                            firstCollisionY = cart.location.y
                        }
                    }
                    
                    // get the next turn for the cart
                    let track = trackGrid[cart.location.y][cart.location.x]
                    if track == .CornerSlash {
                        if cart.travelDirection == .Up || cart.travelDirection == .Down {
                            cart.travelDirection = cart.travelDirection.turnRight()
                        } else {
                            cart.travelDirection = cart.travelDirection.turnLeft()
                        }
                    } else if track == .CornerBackslash {
                        if cart.travelDirection == .Left || cart.travelDirection == .Right {
                            cart.travelDirection = cart.travelDirection.turnRight()
                        } else {
                            cart.travelDirection = cart.travelDirection.turnLeft()
                        }
                    } else if track == .Intersection {
                        if cart.nextTurnDirection == .Left {
                            cart.travelDirection = cart.travelDirection.turnLeft()
                            cart.nextTurnDirection = .Straight
                        } else if cart.nextTurnDirection == .Straight {
                            cart.nextTurnDirection = .Right
                        } else {
                            cart.travelDirection = cart.travelDirection.turnRight()
                            cart.nextTurnDirection = .Left
                        }
                    }
                }
            }
            
            carts = carts.filter { $0.ghost == false }

            tickCount += 1
        } while carts.count > 1
        
        return ((firstCollisionX, firstCollisionY), (carts[0].location.x, carts[0].location.y))
    }
    
}
