//
//  Range.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/5/25.
//

import Foundation


extension Array {
    func makeUnique<Bound: Strideable & Comparable & Numeric>() -> [ClosedRange<Bound>] where Element == ClosedRange<Bound> {
        var uniqued = [ClosedRange<Bound>]()
        
        for range in self {
            var newRanges = [range]
            for range in uniqued {
                newRanges = newRanges.flatMap { newRange in
                    if range.overlaps(newRange) {
                        // Swallowed by other range
                        if newRange.lowerBound >= range.lowerBound && newRange.upperBound <= range.upperBound {
                            return [ClosedRange<Bound>]()
                        }
                        // New is higher
                        else if newRange.lowerBound >= range.lowerBound && newRange.upperBound > range.upperBound {
                            return [(range.upperBound + 1)...newRange.upperBound]
                        }
                        // New is lower
                        else if newRange.lowerBound < range.lowerBound && newRange.upperBound <= range.upperBound {
                            return [newRange.lowerBound...(range.lowerBound - 1)]
                        }
                        // New is inset
                        else if newRange.lowerBound < range.lowerBound && newRange.upperBound > range.upperBound {
                            return [newRange.lowerBound...(range.lowerBound - 1), (range.upperBound + 1)...newRange.upperBound]
                        }
                        else {
                            fatalError()
                        }
                    }
                    else {
                        return [newRange]
                    }
                }
            }
            uniqued.append(contentsOf: newRanges)
        }
        
        return uniqued
    }
}
