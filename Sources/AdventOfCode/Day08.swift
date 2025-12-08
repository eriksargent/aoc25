import Foundation
import Algorithms


struct Day08: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var numberOfConnectionsToMake: Int
    
    init(data: String) {
        self.init(data: data, numberOfConnectionsToMake: 1000)
    }
    
    init(data: String, numberOfConnectionsToMake: Int) {
        self.data = data
        self.numberOfConnectionsToMake = numberOfConnectionsToMake
    }
    
    struct Point: Equatable {
        var x: Int
        var y: Int
        var z: Int
        
        func distance2(to other: Point) -> Int {
            let a = (x - other.x)
            let b = (y - other.y)
            let c = (z - other.z)
            return a * a + b * b + c * c
        }
        
        init?(from string: String) {
            let comps = string.components(separatedBy: .punctuationCharacters).compactMap(Int.init)
            guard comps.count == 3 else { return nil }
            
            x = comps[0]
            y = comps[1]
            z = comps[2]
        }
    }
    
    func parsePoints() -> [Point] {
        data.components(separatedBy: .newlines)
            .filter({ !$0.isEmpty })
            .compactMap({ Point(from: $0) })
    }
    
    func part1() -> Any {
        let points = parsePoints()
        let options = points
            .combinations(ofCount: 2)
            .sorted(by: { $0[0].distance2(to: $0[1]) < $1[0].distance2(to: $1[1]) })
            .prefix(numberOfConnectionsToMake)
        
        var circuits = [[Point]]()
        for pair in options {
            let foundLeft = circuits.firstIndex(where: { $0.contains(pair[0]) })
            let foundRight = circuits.firstIndex(where: { $0.contains(pair[1]) })
            
            if let foundLeft, let foundRight {
                if foundLeft == foundRight {
                    continue
                }
                circuits[foundLeft].append(contentsOf: circuits[foundRight])
                circuits.remove(at: foundRight)
            }
            else if let foundLeft {
                circuits[foundLeft].append(pair[1])
            }
            else if let foundRight {
                circuits[foundRight].append(pair[0])
            }
            else {
                circuits.append(pair)
            }
        }
        
        return circuits.map(\.count).sorted(by: >).prefix(3).reduce(1, *)
    }
    
    func part2() -> Any {
        let points = parsePoints()
        let options = points
            .combinations(ofCount: 2)
            .sorted(by: { $0[0].distance2(to: $0[1]) < $1[0].distance2(to: $1[1]) })
        
        let targetSize = points.count
        
        var circuits = [[Point]]()
        for pair in options {
            let foundLeft = circuits.firstIndex(where: { $0.contains(pair[0]) })
            let foundRight = circuits.firstIndex(where: { $0.contains(pair[1]) })
            
            if let foundLeft, let foundRight {
                if foundLeft == foundRight {
                    continue
                }
                circuits[foundLeft].append(contentsOf: circuits[foundRight])
                circuits.remove(at: foundRight)
            }
            else if let foundLeft {
                circuits[foundLeft].append(pair[1])
            }
            else if let foundRight {
                circuits[foundRight].append(pair[0])
            }
            else {
                circuits.append(pair)
            }
            
            if circuits.first?.count == targetSize {
                // Found the last connection!
                return pair[0].x * pair[1].x
            }
        }
        
        return 0
    }
}
