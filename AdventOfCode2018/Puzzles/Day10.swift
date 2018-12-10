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
        //let puzzleInput = Day10PuzzleInput.puzzleInput_test
        let puzzleInput = Day10PuzzleInput.puzzleInput
        
        runSimulation(pointsOfLight: puzzleInput)
    }

    func parsePointsOfLight(pointsOfLight: String) -> [Particle2D] {
        var retval: [Particle2D] = []
        
        let arr = pointsOfLight.parseIntoStringArray()
        for line in arr {
            let components = line.capturedGroups(withRegex: "position=<(.*),(.*)> velocity=<(.*),(.*)>", trimResults: true)
            var particle = Particle2D()
            particle.x = Int(components[0])!
            particle.y = Int(components[1])!
            particle.deltaX = Int(components[2])!
            particle.deltaY = Int(components[3])!
            retval.append(particle)
        }
        
        return retval
    }
    
    func runSimulation(pointsOfLight: String) {
        var secondsElapsed = 0
        var particles = parsePointsOfLight(pointsOfLight: pointsOfLight)
        var particleString: String
        repeat {
            let bounds = Particle2D.boundingRectangle(arr: particles)
            if bounds.y2 - bounds.y1 < 20 {
                particleString = Particle2D.gridString(arr: particles)
                if particleString.contains("#####") {
                    print("At seconds elapsed \(secondsElapsed), the particles look like this:")
                    print(particleString)
                    print("Press enter to continue")
                    let _ = readLine()
                }
            }
            
            secondsElapsed += 1
            for idx in 0..<particles.count {
                particles[idx].x += particles[idx].deltaX
                particles[idx].y += particles[idx].deltaY
            }
            
        } while secondsElapsed < 20000
    }
    
}
