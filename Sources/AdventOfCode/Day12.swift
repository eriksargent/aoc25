import Foundation
import Algorithms
import RegexBuilder


struct Day12: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    struct Present {
        var shape: [[Bool]]
        var pixels: Int
        var id: Int
        
        init?(from string: String) {
            guard let match = string.firstMatch(of: /^(\d):\n((?:[#\.]{3}\n?){3})/)?.output else { return nil }
            
            guard let id = Int(match.1) else { return nil }
            
            let shapeLines = match.2.components(separatedBy: .newlines)
            guard shapeLines.count == 3 else { return nil }
            
            let shape = shapeLines.map({ line in line.map({ $0 == "#" }) })
            guard shape.allSatisfy({ $0.count == 3 }) else { return nil }
            
            self.shape = shape
            self.pixels = shape.map({ $0.filter({ $0 }).count }).sum()
            self.id = id
        }
    }
    
    struct Region {
        var width: Int
        var height: Int
        var quantities: [Int]
        var totalPresents: Int
        
        init?(from string: String) {
            guard let match = string.firstMatch(of: /^(\d+x\d+):([ \d+]+)$/)?.output else { return nil }
            
            let sizeComps = match.1.components(separatedBy: "x").compactMap(Int.init)
            guard sizeComps.count == 2 else { return nil }
            
            self.width = sizeComps[0]
            self.height = sizeComps[1]
            
            self.quantities = match.2.components(separatedBy: .whitespaces).compactMap(Int.init)
            self.totalPresents = quantities.sum()
        }
    }
    
    func part1() -> Any {
        let inputGroups = data.components(separatedBy: "\n\n")
        
        var presents = [Present]()
        var regions = [Region]()
        var parsingPresents = true
        for group in inputGroups {
            if parsingPresents {
                if let present = Present(from: group) {
                    presents.append(present)
                }
                else {
                    parsingPresents = false
                }
            }
            
            if !parsingPresents {
                for line in group.components(separatedBy: .newlines) {
                    if let region = Region(from: line) {
                        regions.append(region)
                    }
                }
            }
        }
        
        var possible = 0
        for region in regions {
            let area = region.width * region.height
            if 9 * region.totalPresents <= area {
                possible += 1
            }
        }
        
        return possible
    }
    
    func part2() -> Any {
        return 0
    }
}
