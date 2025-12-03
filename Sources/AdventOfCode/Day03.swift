import Foundation
import Algorithms


struct Day03: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    func part1() -> Any {
        let lines = data.components(separatedBy: .whitespacesAndNewlines).filter({ !$0.isEmpty })
        
        var sum = 0
        
        for line in lines where line.count >= 2 {
            var maxIndex = 0
            var maxChar = "0".first!
            for (index, char) in line.enumerated().dropLast() {
                if char > maxChar {
                    maxChar = char
                    maxIndex = index
                }
            }
            
            guard let second = line[line.index(line.startIndex, offsetBy: maxIndex + 1)...].max() else { fatalError() }
            
            let value = Int(String([maxChar, second])) ?? 0
            
            sum += value
        }
        
        return sum
    }
    
    func part2() -> Any {
        let lines = data.components(separatedBy: .whitespacesAndNewlines).filter({ !$0.isEmpty })
        
        var sum = 0
        
        for line in lines where line.count >= 2 {
            let value = Int(String(Substring(line).largestSequence(of: 12) ?? [])) ?? 0
            
            sum += value
        }
        
        return sum
    }
}


extension Substring {
    func largestSequence(of length: Int) -> [Character]? {
        guard length >= 1 else { return nil }
        if count < length { return nil }
        if count == length { return Array(self) }
        
        var maxIndex = 0
        var maxChar = self.first!
        for (index, char) in self.enumerated().dropLast(length - 1) {
            if char > maxChar {
                maxChar = char
                maxIndex = index
            }
        }
        
        return [maxChar] + (self[self.index(self.startIndex, offsetBy: maxIndex + 1)...].largestSequence(of: length - 1) ?? [])
    }
}
