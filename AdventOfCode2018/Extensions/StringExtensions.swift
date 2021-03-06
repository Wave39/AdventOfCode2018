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
        guard let retval = Int(self.trim()) else { return 0 }
        return retval
    }
    
    var asciiValue: UInt32 {
        let c = self.unicodeScalars.first
        return c?.value ?? 0
    }

    func parseIntoStringArray() -> [String] {
        return parseIntoStringArray(separator: "\n")
    }
    
    func parseIntoStringArray(separator: Character) -> [String] {
        let arr = self.split(separator: separator)
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
    
    mutating func removeAtIndex(idx: Int) {
        if let index = self.index(self.startIndex, offsetBy: idx, limitedBy: self.endIndex) {
            self.remove(at: index)
        }
    }
    
    func capturedGroups(withRegex pattern: String, trimResults: Bool = false) -> [String] {
        var results = [String]()
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        guard let match = matches.first else { return results }
        
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            if trimResults {
                results.append(matchedString.trim())
            } else {
                results.append(matchedString)
            }
        }
        
        return results
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
