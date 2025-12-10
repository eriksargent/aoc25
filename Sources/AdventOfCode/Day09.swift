import Foundation
import Algorithms

import CoreGraphics


struct Day09: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    struct Point: Equatable {
        var x: Int
        var y: Int
        
        init?(from string: String) {
            let comps = string.components(separatedBy: .punctuationCharacters).compactMap(Int.init)
            guard comps.count == 2 else { return nil }
            
            x = comps[0]
            y = comps[1]
        }
        
        var cgPoint: CGPoint {
            CGPoint(x: Double(x), y: Double(y))
        }
        
        func makeRect(to other: Point) -> CGPath {
            let rect = CGRect(origin: cgPoint, size: CGSize(width: other.x - x, height: other.y - y))
            return CGPath(rect: rect, transform: nil)
        }
    }
    
    func part1() -> Any {
        let points = data.components(separatedBy: .newlines).filter({ !$0.isEmpty }).compactMap(Point.init)
        
        return points
            .combinations(ofCount: 2)
            .map { (abs($0[0].x - $0[1].x) + 1) * (abs($0[0].y - $0[1].y) + 1) }
            .max() ?? 0
    }
    
    func part2() async -> Any {
        let points = data.components(separatedBy: .newlines).filter({ !$0.isEmpty }).compactMap(Point.init)
        
        let path = CGMutablePath()
        if let first = points.first {
            path.move(to: first.cgPoint)
        }
        
        for point in points.dropFirst() {
            path.addLine(to: point.cgPoint)
        }
        
        if let first = points.first {
            path.addLine(to: first.cgPoint)
        }
        
        path.closeSubpath()
        let staticPath = path.copy()!
        
        let rectOptions = await Array(points.combinations(ofCount: 2))
            .threadedFilter {
                let testRect = $0[0].makeRect(to: $0[1])
                return testRect.subtracting(staticPath).isEmpty
            }
        
        return rectOptions
            .map { (abs($0[0].x - $0[1].x) + 1) * (abs($0[0].y - $0[1].y) + 1) }
            .max() ?? 0
    }
}


extension CGPath: @unchecked @retroactive Sendable {}
