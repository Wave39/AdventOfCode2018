//
//  Day16.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/16/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day16: NSObject {

    typealias Registers = [Int]
    typealias Command = [Int]
    
    class Sample : CustomStringConvertible {
        var beforeRegisters: Registers = Registers()
        var command: Command = Command()
        var afterRegisters: Registers = Registers()
        var description: String {
            return "Before: \(beforeRegisters); Command: \(command); After: \(afterRegisters)"
        }
    }
    
    public func solve() {
        let puzzleInput = Day16PuzzleInput.puzzleInput
        
        var samples: [Sample] = []
        var testProgram: [Command] = []
        let arr = puzzleInput.parseIntoStringArray()
        var buildingSample = false
        var singleSample: Sample = Sample()
        for line in arr {
            if line.starts(with: "Before") {
                buildingSample = true
                singleSample = Sample()
                let components = line.capturedGroups(withRegex: "Before: \\[(.*), (.*), (.*), (.*)\\]", trimResults: true)
                singleSample.beforeRegisters = [ Int(components[0])!, Int(components[1])!, Int(components[2])!, Int(components[3])! ]
            } else if line.starts(with: "After") {
                let components = line.capturedGroups(withRegex: "After:  \\[(.*), (.*), (.*), (.*)\\]", trimResults: true)
                singleSample.afterRegisters = [ Int(components[0])!, Int(components[1])!, Int(components[2])!, Int(components[3])! ]
                samples.append(singleSample)
                buildingSample = false
            } else if line.count > 0 {
                let components = line.capturedGroups(withRegex: "(.*) (.*) (.*) (.*)", trimResults: true)
                if buildingSample {
                    singleSample.command = [ Int(components[0])!, Int(components[1])!, Int(components[2])!, Int(components[3])! ]
                } else {
                    testProgram.append([ Int(components[0])!, Int(components[1])!, Int(components[2])!, Int(components[3])! ])
                }
            }
        }

        let part1 = solvePart1(samples: samples)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(originalSamples: samples, testProgram: testProgram)
        print ("Part 2 solution: \(part2)")
    }
    
    public func solvePart1(samples: [Sample]) -> Int {
        let opcodes = [ "addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr" ]
        
        var retval = 0
        for sample in samples {
            var candidateArray: [String] = []
            for opcode in opcodes {
                let results = runCommandString(command: sample.command, registers: sample.beforeRegisters, commandString: opcode)
                if results == sample.afterRegisters {
                    candidateArray.append(opcode)
                }
            }
            
            if candidateArray.count >= 3 {
                retval += 1
            }
        }
        
        return retval
    }
    
    public func solvePart2(originalSamples: [Sample], testProgram: [Command]) -> Int {
        var newSamples = originalSamples
        var opcodes = [ "addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr" ]
        var mappingDict: Dictionary<Int, String> = [:]
        
        // figure out which numbers match which opcodes by iterating through the samples
        // when only one candidate is found, that number must match that opcode
        while mappingDict.count < 16 {
            var itemsToRemove: Set<Int> = Set()
            for sample in newSamples {
                var candidateArray: [String] = []
                for opcode in opcodes {
                    let results = runCommandString(command: sample.command, registers: sample.beforeRegisters, commandString: opcode)
                    if results == sample.afterRegisters {
                        candidateArray.append(opcode)
                    }
                }
                
                if candidateArray.count == 1 {
                    mappingDict[sample.command[0]] = candidateArray[0]
                    itemsToRemove.insert(sample.command[0])
                    opcodes.removeAll { $0 == candidateArray[0] }
                }
            }
            
            for x in itemsToRemove {
                newSamples = newSamples.filter { $0.command[0] != x }
            }
        }
        
        var registers = [ 0, 0, 0, 0 ]
        for c in testProgram {
            registers = runCommandString(command: c, registers: registers, commandString: mappingDict[c[0]]!)
        }
        
        return registers[0]
    }

    public func runCommandString(command: Command, registers: Registers, commandString: String) -> Registers {
        var newRegisters = registers
        let a = command[1]
        let b = command[2]
        let c = command[3]
        if commandString == "addr" {
            newRegisters[c] = registers[a] + registers[b]
        } else if commandString == "addi" {
            newRegisters[c] = registers[a] + b
        } else if commandString == "mulr" {
            newRegisters[c] = registers[a] * registers[b]
        } else if commandString == "muli" {
            newRegisters[c] = registers[a] * b
        } else if commandString == "banr" {
            newRegisters[c] = registers[a] & registers[b]
        } else if commandString == "bani" {
            newRegisters[c] = registers[a] & b
        } else if commandString == "borr" {
            newRegisters[c] = registers[a] | registers[b]
        } else if commandString == "bori" {
            newRegisters[c] = registers[a] | b
        } else if commandString == "setr" {
            newRegisters[c] = registers[a]
        } else if commandString == "seti" {
            newRegisters[c] = a
        } else if commandString == "gtir" {
            newRegisters[c] = (a > registers[b] ? 1 : 0)
        } else if commandString == "gtri" {
            newRegisters[c] = (registers[a] > b ? 1 : 0)
        } else if commandString == "gtrr" {
            newRegisters[c] = (registers[a] > registers[b] ? 1 : 0)
        } else if commandString == "eqir" {
            newRegisters[c] = (a == registers[b] ? 1 : 0)
        } else if commandString == "eqri" {
            newRegisters[c] = (registers[a] == b ? 1 : 0)
        } else if commandString == "eqrr" {
            newRegisters[c] = (registers[a] == registers[b] ? 1 : 0)
        }
        
        return newRegisters
    }
    
}
