import Foundation
import Algorithms


struct Day06: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    func part1() -> Any {
        let lines = data.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard lines.count > 2,
              let shouldMultiply = lines.last?
            .components(separatedBy: .whitespaces)
            .filter({ !$0.isEmpty })
            .map({ $0 == "*" }) else { return 0 }
        
        let numbers = lines.dropLast().map { line in
            line.components(separatedBy: .whitespaces)
                .compactMap(Int.init)
        }
        
        var answers = numbers[0]
        
        for row in numbers.dropFirst() {
            for (index, value) in row.enumerated() {
                if shouldMultiply[index] {
                    answers[index] = answers[index] * value
                }
                else {
                    answers[index] = answers[index] + value
                }
            }
        }
        
        return answers.sum()
    }
    
    func part2() -> Any {
        let lines = data.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        let grid = lines.map { Array.init($0) }
        
        guard grid.count > 0 && grid[0].count > 0 else { return 0 }
        
        let width = grid[0].count
        let height = grid.count
        
        var answerSum = 0
        
        var numbers = [Int]()
        for column in (0..<width).reversed() {
            var runningString = ""
            for row in 0..<(height - 1) {
                let value = grid[row][column]
                if value != " " {
                    runningString.append(value)
                }
            }
            
            if runningString == "" {
                numbers = []
                continue // Column spacer row
            }
            if let value = Int(runningString) {
                numbers.append(value)
            }
            
            let op = grid[height - 1][column]
            if op == "*" {
                answerSum += numbers.reduce(1, *)
            }
            else if op == "+" {
                answerSum += numbers.sum()
            }
            else {
                continue // More numbers to parse first
            }
        }
        
        return answerSum
    }
}
