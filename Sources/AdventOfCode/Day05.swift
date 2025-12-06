import Foundation
import Algorithms
import RegexBuilder


struct Day05: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    func parse() -> ([ClosedRange<Int>], [Int]) {
        var ranges = [ClosedRange<Int>]()
        var ingredients = [Int]()
        
        let groups = data.components(separatedBy: "\n\n")
        
        guard groups.count == 2 else { fatalError() }
        
        ranges = groups[0]
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .compactMap {
                if let match = $0.firstMatch(of: /(\d+)-(\d+)/),
                   let start = Int(match.output.1),
                   let end = Int(match.output.2) {
                    return start...end
                }
                return nil
            }
        ingredients = groups[1]
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .compactMap(Int.init)
        
        return (ranges, ingredients)
    }
    
    func part1() -> Any {
        let (ranges, ingredients) = parse()
        
        return ingredients.filter { ingredient in
            ranges.contains(where: { $0.contains(ingredient) })
        }
        .count
    }
    
    func part2() -> Any {
        let (ranges, _) = parse()
        let uniqued = ranges.makeUnique()
        return uniqued.map({ $0.count }).sum()
    }
}
