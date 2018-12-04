//
//  Day04.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/4/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

class Day04: NSObject {

    public func solve() {
        let puzzleInput = Day04PuzzleInput.puzzleInput
        let sleepRecords = SleepRecord.parse(str: puzzleInput)
        
        let part1 = solvePart1(sleepRecords: sleepRecords)
        print ("Part 1 solution: \(part1)")
        let part2 = solvePart2(sleepRecords: sleepRecords)
        print ("Part 2 solution: \(part2)")
    }

    func solvePart1(sleepRecords: [SleepRecord]) -> Int {
        var timeDictionary: Dictionary<Int, Int> = Dictionary()
        for rec in sleepRecords {
            if timeDictionary[rec.idNumber] == nil {
                timeDictionary[rec.idNumber] = rec.minuteArray.minutesAsleep
            } else {
                timeDictionary[rec.idNumber] = timeDictionary[rec.idNumber]! + rec.minuteArray.minutesAsleep
            }
        }

        var maxId = 0
        var maxMinutesAsleep = 0
        for (k, v) in timeDictionary {
            if v > maxMinutesAsleep {
                maxId = k
                maxMinutesAsleep = v
            }
        }
        
        let sleepTimes = MinuteArray()
        for rec in sleepRecords {
            if rec.idNumber == maxId {
                sleepTimes.accumulate(minuteArray: rec.minuteArray)
            }
        }
        
        var maxMinute = -1
        var maxMinuteValue = Int.min
        for idx in 0...59 {
            if sleepTimes.minute[idx] > maxMinuteValue {
                maxMinute = idx
                maxMinuteValue = sleepTimes.minute[idx]
            }
        }
        
        return maxId * maxMinute
    }
    
    func solvePart2(sleepRecords: [SleepRecord]) -> Int {
        var guardDictionary: Dictionary<Int, MinuteArray> = Dictionary()
        for rec in sleepRecords {
            if guardDictionary[rec.idNumber] == nil {
                guardDictionary[rec.idNumber] = rec.minuteArray;
            } else {
                guardDictionary[rec.idNumber]?.accumulate(minuteArray: rec.minuteArray)
            }
        }
        
        var maxId = 0
        var maxMinuteValue = Int.min
        var maxIndex = 0
        for (k, v) in guardDictionary {
            for idx in 0...59 {
                if v.minute[idx] > maxMinuteValue {
                    maxMinuteValue = v.minute[idx]
                    maxIndex = idx
                    maxId = k
                }
            }
        }
        
        return maxId * maxIndex
    }
    
    class MinuteArray {
        var minute: [Int]
        init() {
            minute = []
            for _ in 0...59 {
                minute.append(0)
            }
        }
        
        var minutesAsleep: Int {
            var retval = 0
            for b in minute {
                if b > 0 {
                    retval += 1
                }
            }
            
            return retval
        }
        
        func accumulate(minuteArray: MinuteArray) {
            for idx in 0...59 {
                self.minute[idx] += minuteArray.minute[idx]
            }
        }
    }
    
    class SleepRecord {
        var idNumber: Int = 0
        var date: String = ""
        var minuteArray: MinuteArray = MinuteArray()
        
        static func parse(str: String) -> [SleepRecord] {
            let arr = str.parseIntoStringArray().sorted()
            var retval: [SleepRecord] = []
            var currentGuardId = 0
            var currentDate = ""
            var currentAsleepTime = 0
            var currentWakeTime = 0
            for line in arr {
                let split1 = line.parseIntoStringArray(separator: "]")
                let split2 = split1[0].parseIntoStringArray(separator: " ")
                let lineDate = split2[0].replacingOccurrences(of: "[", with: "")
                let lineTime = split2[1]
                let lineEvent = split1[1].trim()
                if lineEvent.starts(with: "Guard") {
                    let split3 = lineEvent.parseIntoStringArray(separator: " ")
                    currentGuardId = split3[1].replacingOccurrences(of: "#", with: "").toInt()
                } else if lineEvent.starts(with: "falls") {
                    currentDate = lineDate
                    currentAsleepTime = lineTime.replacingOccurrences(of: ":", with: "").toInt()
                } else if lineEvent.starts(with: "wakes") {
                    currentWakeTime = lineTime.replacingOccurrences(of: ":", with: "").toInt()
                    var idx = -1
                    for i in 0..<retval.count {
                        if retval[i].idNumber == currentGuardId && retval[i].date == currentDate {
                            idx = i
                        }
                    }
                    
                    if idx == -1 {
                        let rec = SleepRecord()
                        rec.idNumber = currentGuardId
                        rec.date = currentDate
                        retval.append(rec)
                        idx = retval.count - 1
                    }
                    
                    for i in currentAsleepTime..<currentWakeTime {
                        retval[idx].minuteArray.minute[i] = 1
                    }
                } else {
                    print ("********************* Invalid line event *********************")
                }
            }
            
            return retval
        }
    }
}
