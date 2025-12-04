import Foundation
import Algorithms


struct Day04: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var grid: [[Bool]]
    
    init(data: String) {
        self.data = data
        self.grid = data.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { line in
                line.map { $0 == "@" }
            }
    }
    
    func isSpaceAvailable(atRow row: Int, col: Int) -> Bool {
        var surrounding = 0
        var rowMin = row - 1
        if rowMin < 0 {
            rowMin = 0
        }
        var rowMax = row + 1
        if rowMax > grid.count - 1 {
            rowMax = grid.count - 1
        }
        for rowIndex in rowMin...rowMax {
            if col > 0, grid[rowIndex][col - 1] {
                surrounding += 1
            }
            if rowIndex != row && grid[rowIndex][col] {
                surrounding += 1
            }
            if col < grid[rowIndex].count - 1, grid[rowIndex][col + 1] {
                surrounding += 1
            }
        }
        
        return surrounding < 4
    }
    
    func getRemovable() -> [(Int, Int)] {
        var removable: [(Int, Int)] = []
        for (rowIndex, row) in grid.enumerated() {
            for (colIndex, space) in row.enumerated() {
                if space && isSpaceAvailable(atRow: rowIndex, col: colIndex) {
                    removable.append((rowIndex, colIndex))
                }
            }
        }
        return removable
    }
    
    func part1() -> Any {
        return getRemovable().count
    }
    
    func part2() -> Any {
        var mutable = Day04(data: data)
        return mutable.calculatePart2()
    }
    
    mutating func calculatePart2() -> Any {
        var count = 0
        var removable = getRemovable()
        while !removable.isEmpty {
            count += removable.count
            for (row, col) in removable {
                grid[row][col] = false
            }
            removable = getRemovable()
        }
        return count
    }
}
