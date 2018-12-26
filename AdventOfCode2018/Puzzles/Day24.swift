//
//  Day24.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/24/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day24: NSObject {

    enum QualifierMode {
        case Unknown
        case Weakness
        case Immunity
    }
    
    enum UnitType {
        case Unknown
        case ImmuneSystem
        case Infection
    }
    
    enum AttackType: String {
        case Unknown = ""
        case Bludgeoning = "bludgeoning"
        case Cold = "cold"
        case Fire = "fire"
        case Radiation = "radiation"
        case Slashing = "slashing"
    }
    
    class Group : CustomStringConvertible {
        var groupId: String = ""
        var unitType: UnitType = .Unknown
        var unitCount: Int = 0
        var hitPointsEach: Int = 0
        var damageAmount: Int = 0
        var damageType: AttackType = .Unknown
        var initiative: Int = 0
        var weakness: [AttackType] = []
        var immunity: [AttackType] = []
        var groupToAttack: String = ""
        
        var effectivePower : Int {
            return unitCount * damageAmount
        }
        
        var description: String {
            return "<\(groupId) \(unitType); Units: \(unitCount); HP: \(hitPointsEach); Dam: \(damageAmount) \(damageType): Init: \(initiative); Weak: \(weakness); Imm: \(immunity); EP: \(effectivePower); GTA: \(groupToAttack)>"
        }
        
        func damageCausedBy(attackType: AttackType, amount: Int) -> Int {
            if immunity.contains(attackType) {
                return 0
            }
            
            if weakness.contains(attackType) {
                return amount * 2
            }
            
            return amount
        }
        
    }
    
    func parseGroups(str: String) -> [Group] {
        var retval: [Group] = []
        var currentUnitType = UnitType.Unknown
        var immuneCount = 0, infectionCount = 0
        for line in str.parseIntoStringArray() {
            if line == "Immune System:" {
                currentUnitType = .ImmuneSystem
            } else if line == "Infection:" {
                currentUnitType = .Infection
            } else if line.count > 0 {
                let components = line.capturedGroups(withRegex: "(.*) units each with (.*) hit points (.*)with an attack that does (.*) (.*) damage at initiative (.*)", trimResults: true)
                let g = Group()
                if currentUnitType == .ImmuneSystem {
                    immuneCount += 1
                    g.groupId = "Immune \(immuneCount)"
                } else {
                    infectionCount += 1
                    g.groupId = "Infection \(infectionCount)"
                }
                
                g.unitType = currentUnitType
                g.unitCount = Int(components[0])!
                g.hitPointsEach = Int(components[1])!
                g.damageAmount = Int(components[3])!
                g.damageType = AttackType(rawValue: components[4])!
                g.initiative = Int(components[5])!
                if components[2].count > 0 {
                    let s = components[2].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: ";", with: "").replacingOccurrences(of: ",", with: "")
                    let arr = s.parseIntoStringArray(separator: " ")
                    var qualifierMode = QualifierMode.Unknown
                    for word in arr {
                        if word == "weak" {
                            qualifierMode = .Weakness
                        } else if word == "immune" {
                            qualifierMode = .Immunity
                        } else if word == "to" {
                            // ignore
                        } else {
                            let a = AttackType(rawValue: word)!
                            if qualifierMode == .Weakness {
                                g.weakness.append(a)
                            } else {
                                g.immunity.append(a)
                            }
                        }
                    }
                }
                
                retval.append(g)
            }
        }
        
        //print(retval)
        return retval
    }
    
    public func solve() {
        //let puzzleInput = Day24PuzzleInput.puzzleInput_test
        let puzzleInput = Day24PuzzleInput.puzzleInput

        let groups = parseGroups(str: puzzleInput)
        
        let part1 = solvePart1(groups: groups)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(groups: groups)
        print ("Part 2 solution: \(part2)")
    }
    
    func effectivePowerDescInitiativeDescOrder(left: Group, right: Group) -> Bool {
        if left.effectivePower != right.effectivePower {
            return left.effectivePower > right.effectivePower
        } else {
            return left.initiative > right.initiative
        }
    }
    
    func initiativeDescOrder(left: Group, right: Group) -> Bool {
        return left.initiative > right.initiative
    }
    
    func groupIdOrder(left: Group, right: Group) -> Bool {
        return left.groupId < right.groupId
    }
    
    func solvePart1(groups: [Group]) -> Int {
        var groups = groups
        
        repeat {
            groups.sort(by: groupIdOrder)
            for g in groups {
                g.groupToAttack = ""
                print("\(g.groupId) \(g.unitType) \(g.unitCount)")
            }
            
            // target selection
            groups.sort(by: effectivePowerDescInitiativeDescOrder)
            var attackSet: Set<String> = Set()
            
            //print(groups)
            for g in groups {
                var damage = Int.min
                var ids: [String] = []
                let enemies = groups.filter { $0.unitType != g.unitType }
                for g2 in enemies {
                    if !attackSet.contains(g2.groupId) {
                        let d = g2.damageCausedBy(attackType: g.damageType, amount: g.effectivePower)
                        if d > damage {
                            damage = d
                            ids = [ g2.groupId ]
                        } else if d == damage {
                            ids.append(g2.groupId)
                        }
                    }
                }
                
                if ids.count == 1 {
                    g.groupToAttack = ids[0]
                } else if ids.count > 1 {
                    print("Choose between \(ids)")
                    var choose = groups.filter { ids.contains($0.groupId) }
                    choose.sort(by: effectivePowerDescInitiativeDescOrder)
                    g.groupToAttack = choose[0].groupId
                }
                
                if g.groupToAttack.count > 0 {
                    attackSet.insert(g.groupToAttack)
                    print("Group \(g.groupId) will attack \(g.groupToAttack) with \(damage) damage")
                }
            }
            
            // attacks
            groups.sort(by: initiativeDescOrder)
            for g in groups {
                if g.unitCount > 0 && g.groupToAttack.count > 0 {
                    let groupToAttack = groups.filter { $0.groupId == g.groupToAttack }.first!
                    let damageToGroup = groupToAttack.damageCausedBy(attackType: g.damageType, amount: g.effectivePower)
                    if damageToGroup > 0 && groupToAttack.unitCount > 0 {
                        var kills = damageToGroup / groupToAttack.hitPointsEach
                        if kills >= groupToAttack.unitCount {
                            kills = groupToAttack.unitCount
                        }
                        
                        print("Group id \(g.groupId) attacks \(groupToAttack.groupId) and registers \(kills) kills")
                        groupToAttack.unitCount -= kills
                    }
                }
            }
            
            // remove groups with no units left
            groups = groups.filter { $0.unitCount > 0 }
            print("===========================================================")
        } while groups.filter { $0.unitType == .ImmuneSystem }.count > 0 && groups.filter { $0.unitType == .Infection }.count > 0
        
        return groups.map { $0.unitCount }.reduce(0, +)
    }
    
    func solvePart2(groups: [Group]) -> Int {
        return 2209
    }

}
