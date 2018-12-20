//
//  Stack.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/20/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

struct Stack<T> {
    var array: [T] = []
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        if !array.isEmpty {
            let index = array.count - 1
            let poppedValue = array.remove(at: index)
            return poppedValue
        } else {
            return nil
        }
    }
    
    func peek() -> T? {
        if !array.isEmpty {
            return array.last
        } else {
            return nil
        }
    }
    
}
