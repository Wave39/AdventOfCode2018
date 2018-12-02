//
//  StringExtensions.swift
//  AdventOfCode2018
//
//  Created by Brian Prescott on 12/2/18.
//  Copyright © 2018 Brian Prescott. All rights reserved.
//

import Cocoa

extension String {

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toInt() -> Int {
        return Int(self.trim())!
    }
    
    func parseIntoStringArray() -> [String] {
        let arr = self.split(separator: "\n")
        var retval: [String] = []
        for s in arr {
            retval.append(String(s))
        }
        
        return retval
    }
    
    var uniqueCharacters: String {
        var set = Set<Character>()
        return String(filter{ set.insert($0).inserted })
    }
    
    func hasConsecutiveCharacters(num: Int) -> Bool {
        let uniqueSelf = self.uniqueCharacters
        for c in uniqueSelf {
            let ctr = self.filter { $0 == c }
            if ctr.count == num {
                return true
            }
        }
        
        return false
    }
    
    func charactersDifferentFrom(str: String) -> Int {
        var retval = 0
        for idx in 0..<self.count {
            if self[idx] != str[idx] {
                retval += 1
            }
        }
        
        return retval
    }
    
    func commonCharactersWith(str: String) -> String {
        var retval = ""
        for idx in 0..<self.count {
            if self[idx] == str[idx] {
                retval += String(self[idx])
            }
        }
        return retval
    }
    
}

extension StringProtocol {
    
    var string: String { return String(self) }
    
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ range: CountableRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: CountableClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}

extension Substring {
    var string: String { return String(self) }
}
