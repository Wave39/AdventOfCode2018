//
//  Day19.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/19/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day19: NSObject {

    typealias Registers = [Int]
    
    class Command {
        var opcode: String = ""
        var a: Int = 0
        var b: Int = 0
        var c: Int = 0
    }
    
    class Program {
        var instructionPointer: Int = 0
        var boundRegister: Int = 0
        var code: [Command] = []
        var registers: Registers = [ 0, 0, 0, 0, 0, 0 ]
    }
    
    func parseIntoProgram(str: String) -> Program {
        let program = Program()
        let arr = str.parseIntoStringArray()
        for line in arr {
            if line.starts(with: "#") {
                let components = line.parseIntoStringArray(separator: " ")
                program.boundRegister = Int(components[1])!
            } else {
                let components = line.capturedGroups(withRegex: "(.*) (.*) (.*) (.*)", trimResults: true)
                let cmd = Command()
                cmd.opcode = components[0]
                cmd.a = Int(components[1])!
                cmd.b = Int(components[2])!
                cmd.c = Int(components[3])!
                program.code.append(cmd)
            }
        }
        
        return program
    }
    
    public func solve() {
        let puzzleInput = Day19PuzzleInput.puzzleInput
        
        let part1 = solvePart1(puzzleInput: puzzleInput)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(puzzleInput: puzzleInput)
        print ("Part 2 solution: \(part2)")
    }
    
    public func solvePart1(puzzleInput: String) -> Int {
        let program = parseIntoProgram(str: puzzleInput)
        
        repeat {
            program.registers[program.boundRegister] = program.instructionPointer
            
            program.registers = runCommandString(command: program.code[program.instructionPointer], registers: program.registers)
            program.instructionPointer = program.registers[program.boundRegister]
            
            program.instructionPointer += 1
        } while program.instructionPointer >= 0 && program.instructionPointer < program.code.count
        
        return program.registers[0]
    }
    
    public func solvePart2(puzzleInput: String) -> Int {
        let program = parseIntoProgram(str: puzzleInput)
        program.registers[0] = 1
        var searchValue = -1
        
        repeat {
            program.registers[program.boundRegister] = program.instructionPointer
            
            program.registers = runCommandString(command: program.code[program.instructionPointer], registers: program.registers)
            program.instructionPointer = program.registers[program.boundRegister]
            
            program.instructionPointer += 1
            
            if program.instructionPointer == 1 {
                // the inner loop beginning at IP 1 is a loop that just adds up factors of register 2
                searchValue = program.registers[2]
            }
        } while searchValue == -1
        
        var total = 0
        for i in 1...Int(Double(searchValue).squareRoot()) {
            if searchValue % i == 0 {
                total += i
                if searchValue / i != i {
                    total += searchValue/i
                }
            }
        }
        
        return total
    }
    
    public func runCommandString(command: Command, registers: Registers) -> Registers {
        var newRegisters = registers
        if command.opcode == "addr" {
            newRegisters[command.c] = registers[command.a] + registers[command.b]
        } else if command.opcode == "addi" {
            newRegisters[command.c] = registers[command.a] + command.b
        } else if command.opcode == "mulr" {
            newRegisters[command.c] = registers[command.a] * registers[command.b]
        } else if command.opcode == "muli" {
            newRegisters[command.c] = registers[command.a] * command.b
        } else if command.opcode == "banr" {
            newRegisters[command.c] = registers[command.a] & registers[command.b]
        } else if command.opcode == "bani" {
            newRegisters[command.c] = registers[command.a] & command.b
        } else if command.opcode == "borr" {
            newRegisters[command.c] = registers[command.a] | registers[command.b]
        } else if command.opcode == "bori" {
            newRegisters[command.c] = registers[command.a] | command.b
        } else if command.opcode == "setr" {
            newRegisters[command.c] = registers[command.a]
        } else if command.opcode == "seti" {
            newRegisters[command.c] = command.a
        } else if command.opcode == "gtir" {
            newRegisters[command.c] = (command.a > registers[command.b] ? 1 : 0)
        } else if command.opcode == "gtri" {
            newRegisters[command.c] = (registers[command.a] > command.b ? 1 : 0)
        } else if command.opcode == "gtrr" {
            newRegisters[command.c] = (registers[command.a] > registers[command.b] ? 1 : 0)
        } else if command.opcode == "eqir" {
            newRegisters[command.c] = (command.a == registers[command.b] ? 1 : 0)
        } else if command.opcode == "eqri" {
            newRegisters[command.c] = (registers[command.a] == command.b ? 1 : 0)
        } else if command.opcode == "eqrr" {
            newRegisters[command.c] = (registers[command.a] == registers[command.b] ? 1 : 0)
        }
        
        return newRegisters
    }

}
