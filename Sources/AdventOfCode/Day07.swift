import Foundation
import Algorithms
import Utils


struct Day07: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    class Manifold {
        let startingLine: [Bool]
        let splitters: [[Bool]]
        let width: Int
        let height: Int
        var beams: [Bool]
        
        init(data: String) {
            var lines = data.components(separatedBy: .newlines).filter({ !$0.isEmpty })
            startingLine = lines.removeFirst().map { $0 == "S" }
            beams = startingLine
            width = beams.count
            
            splitters = lines.map { line in
                line.map { $0 == "^" }
            }
            height = splitters.count
        }
        
        @Memoize
        func countPaths(from index: Int, splitterIndex: Int) -> Int {
            if splitterIndex >= height {
                return 1
            }
            
            if !splitters[splitterIndex][index] {
                return countPaths(from: index, splitterIndex: splitterIndex + 1)
            }
            
            if index > 0 && index < width - 1 {
                return countPaths(from: index - 1, splitterIndex: splitterIndex + 1) +
                countPaths(from: index + 1, splitterIndex: splitterIndex + 1)
            }
            else if index > 0 {
                return countPaths(from: index - 1, splitterIndex: splitterIndex + 1)
            }
            else {
                return countPaths(from: index + 1, splitterIndex: splitterIndex + 1)
            }
        }
    }
    
    func part1() -> Any {
        let manifold = Manifold(data: data)
        var nextBeams = manifold.beams
        var splits = 0
        
        for line in manifold.splitters {
            for (index, isSplitter) in line.enumerated() {
                if isSplitter && manifold.beams[index] {
                    splits += 1
                    nextBeams[index] = false
                    if index > 0 {
                        nextBeams[index - 1] = true
                    }
                    if index < nextBeams.count - 1 {
                        nextBeams[index + 1] = true
                    }
                }
            }
            manifold.beams = nextBeams
        }
        
        return splits
    }
    
    func part2() -> Any {
        let manifold = Manifold(data: data)
        guard let initialIndex = manifold.beams.firstIndex(of: true) else { return 0 }
        return manifold.countPaths(from: initialIndex, splitterIndex: 0)
    }
}
