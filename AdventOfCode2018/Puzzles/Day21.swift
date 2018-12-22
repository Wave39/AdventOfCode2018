//
//  Day21.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/21/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day21: NSObject {

    typealias Registers = [Int]
    
    enum Opcode {
        case unknown
        case addr
        case addi
        case mulr
        case muli
        case banr
        case bani
        case borr
        case bori
        case setr
        case seti
        case gtir
        case gtri
        case gtrr
        case eqir
        case eqri
        case eqrr
    }
    
    let opcodeDict: Dictionary<String, Opcode> = [ "addr": .addr, "addi": .addi, "mulr": .mulr, "muli": .muli,
                                                   "banr": .banr, "bani": .bani, "borr": .borr, "bori": .bori,
                                                   "setr": .setr, "seti": .seti, "gtir": .gtir, "gtri": .gtri,
                                                   "gtrr": .gtrr, "eqir": .eqir, "eqri": .eqri, "eqrr": .eqrr ]
    
    class Command {
        var opcode: Opcode = .unknown
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
                cmd.opcode = opcodeDict[components[0]]!
                cmd.a = Int(components[1])!
                cmd.b = Int(components[2])!
                cmd.c = Int(components[3])!
                program.code.append(cmd)
            }
        }
        
        return program
    }

    public func runCommandString(command: Command, registers: Registers) -> Registers {
        var newRegisters = registers
        if command.opcode == .addr {
            newRegisters[command.c] = registers[command.a] + registers[command.b]
        } else if command.opcode == .addi {
            newRegisters[command.c] = registers[command.a] + command.b
        } else if command.opcode == .mulr {
            newRegisters[command.c] = registers[command.a] * registers[command.b]
        } else if command.opcode == .muli {
            newRegisters[command.c] = registers[command.a] * command.b
        } else if command.opcode == .banr {
            newRegisters[command.c] = registers[command.a] & registers[command.b]
        } else if command.opcode == .bani {
            newRegisters[command.c] = registers[command.a] & command.b
        } else if command.opcode == .borr {
            newRegisters[command.c] = registers[command.a] | registers[command.b]
        } else if command.opcode == .bori {
            newRegisters[command.c] = registers[command.a] | command.b
        } else if command.opcode == .setr {
            newRegisters[command.c] = registers[command.a]
        } else if command.opcode == .seti {
            newRegisters[command.c] = command.a
        } else if command.opcode == .gtir {
            newRegisters[command.c] = (command.a > registers[command.b] ? 1 : 0)
        } else if command.opcode == .gtri {
            newRegisters[command.c] = (registers[command.a] > command.b ? 1 : 0)
        } else if command.opcode == .gtrr {
            newRegisters[command.c] = (registers[command.a] > registers[command.b] ? 1 : 0)
        } else if command.opcode == .eqir {
            newRegisters[command.c] = (command.a == registers[command.b] ? 1 : 0)
        } else if command.opcode == .eqri {
            newRegisters[command.c] = (registers[command.a] == command.b ? 1 : 0)
        } else if command.opcode == .eqrr {
            newRegisters[command.c] = (registers[command.a] == registers[command.b] ? 1 : 0)
        }

        return newRegisters
    }

    public func solve() {
        let puzzleInput = Day21PuzzleInput.puzzleInput
        
        let part1 = solvePart1(puzzleInput: puzzleInput)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(puzzleInput: puzzleInput)
        print ("Part 2 solution: \(part2)")
    }
    
    public func solvePart1(puzzleInput: String) -> Int {
        let program = parseIntoProgram(str: puzzleInput)
        while true {
            program.registers[program.boundRegister] = program.instructionPointer
            
            program.registers = runCommandString(command: program.code[program.instructionPointer], registers: program.registers)
            program.instructionPointer = program.registers[program.boundRegister]
            
            program.instructionPointer += 1
            if program.instructionPointer == 28 {
                return program.registers[2]
            }
        }
    }
    
    public func solvePart2(puzzleInput: String) -> Int {
        let program = parseIntoProgram(str: puzzleInput)
        var registerSet: [Int] = []
        var previous: Int = 0
        repeat {
            program.registers[program.boundRegister] = program.instructionPointer
            
            program.registers = runCommandString(command: program.code[program.instructionPointer], registers: program.registers)
            program.instructionPointer = program.registers[program.boundRegister]
            
            program.instructionPointer += 1
            if program.instructionPointer == 28 {
                if registerSet.contains(program.registers[2]) {
                    return previous
                }
                
                registerSet.append(program.registers[2])
                previous = program.registers[2]
            }
        } while program.instructionPointer >= 0 && program.instructionPointer < program.code.count
        
        return previous
    }
    
}
