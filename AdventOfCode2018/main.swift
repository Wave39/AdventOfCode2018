//
//  main.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/1/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Foundation

print ("")
print ("Welcome to BP's Advent Of Code 2018 Solution Machine.")
print ("Make sure to click in the Output window to enter which puzzle you would like to solve.")

let defaultPuzzle = 1

var quitApp = false
while !quitApp {
    var puzzle = 0
    while !quitApp && (puzzle < 1 || puzzle > 25) {
        print ("")
        print ("Which puzzle would you like the Solution Machine to solve? (Enter a number from 1 to 25, default of \(defaultPuzzle), or Q to quit)")
        let response = readLine()
        if response == "q" || response == "Q" {
            quitApp = true
        } else if response != "" {
            puzzle = Int(response ?? "0")!
        } else {
            puzzle = defaultPuzzle
            print ("Defaulting to puzzle \(defaultPuzzle)")
        }
    }
    
    if !quitApp {
        print ("")
        print ("Solving puzzle \(puzzle), please stand by...")
        
        let start = DispatchTime.now()
        if puzzle == 1 {
            Day01().solve()
        }
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("Time to evaluate puzzle \(puzzle): \(String(format: "%.3f", timeInterval)) seconds")
    }
}

print ("")
print ("Thanks for checking out my Advent Of Code 2018 Solution Machine.")
