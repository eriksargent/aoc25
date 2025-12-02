import Foundation
import Algorithms
import RegexBuilder


struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var ranges: [ClosedRange<Int>] {
        data.matches(of: /(\d+)-(\d+),?/).compactMap { match in
            if let start = Int(match.output.1), let end = Int(match.output.2) {
                return start...end
            }
            return nil
        }
    }
    
    func part1() -> Any {
        let ranges = self.ranges
        
        return ranges
            .filter { range in
                let startDigits = range.lowerBound.numDigits
                let endDigits = range.upperBound.numDigits
                return !(startDigits == endDigits && startDigits % 2 == 1)
            }
            .map { range in
                var idSum = 0
                for value in range where value.numDigits % 2 == 0 {
                    let string = String(value)
                    let length = string.count
                    
                    if string.prefix(length / 2) == string.dropFirst(length / 2) {
                        idSum += value
                    }
                }
                return idSum
            }
            .sum() as Int
    }
    
    func part2() -> Any {
        let ranges = self.ranges
        
        return ranges
            .map { range in
                var idSum = 0
                for value in range {
                    let string = String(value)
                    let length = string.count
                    let patterns = patternSizes(for: length)
                    
                    for pattern in patterns where length / pattern >= 2 {
                        let patternString = string.prefix(pattern)
                        var expanded = ""
                        for _ in 0..<(length / pattern) {
                            expanded.append(contentsOf: patternString)
                        }
                        if expanded == string {
                            idSum += value
                            break
                        }
                    }
                }
                return idSum
            }
            .sum() as Int
    }
    
    func patternSizes(for length: Int) -> [Int] {
        var divisors = [1]
        guard length > 2 else { return divisors }
        
        for i in 2..<length {
            if length % i == 0 {
                divisors.append(i)
            }
        }
        
        return divisors
    }
}


extension Int {
    fileprivate var numDigits: Int {
        Int(log10(Double(self)) + 1)
    }
}
