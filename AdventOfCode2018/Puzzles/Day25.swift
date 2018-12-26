//
//  Day25.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/26/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day25: NSObject {

    class Star {
        var position: Point4D = Point4D()
        var constellationId: Int = 0
    }
    
    typealias StarChart = [Star]
    
    func parseStarChart(str: String) -> StarChart {
        var retval = StarChart()
        for line in str.parseIntoStringArray() {
            let components = line.capturedGroups(withRegex: "(.*),(.*),(.*),(.*)", trimResults: true)
            let star = Star()
            star.position = Point4D(x: Int(components[0])!, y: Int(components[1])!, z: Int(components[2])!, t: Int(components[3])!)
            star.constellationId = retval.count + 1
            retval.append(star)
        }
        
        return retval
    }
    
    public func solve() {
        let starChart = parseStarChart(str: Day25PuzzleInput.puzzleInput)
        
        let part1 = solvePart1(starChart: starChart)
        print ("Part 1 solution: \(part1)") 
    }
    
    public func solvePart1(starChart: StarChart) -> Int {
        var starSwap = true
        while starSwap {
            starSwap = false
            for star in starChart {
                let otherStars = starChart.filter { $0.constellationId != star.constellationId }
                for otherStar in otherStars {
                    if otherStar.position.manhattanDistanceTo(pt: star.position) <= 3 {
                        let matchingStars = starChart.filter { $0.constellationId == otherStar.constellationId }
                        for s in matchingStars {
                            s.constellationId = star.constellationId
                        }

                        starSwap = true
                    }
                }
            }
        }
        
        let constellations = Set(starChart.map { $0.constellationId })
        return constellations.count
    }

}
