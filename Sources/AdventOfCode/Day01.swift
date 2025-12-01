import Foundation
import Algorithms
import RegexBuilder


struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    struct Rotation {
        var dir: Dir
        var clicks: Int
        
        enum Dir: String {
            case left = "L"
            case right = "R"
        }
        
        static func parse(from string: String) -> [Self] {
            let regex = Regex {
                Capture {
                    One(ChoiceOf {
                        "L"
                        "R"
                    })
                }
                Capture {
                    OneOrMore(.digit)
                }
            }
            
            return string.components(separatedBy: .whitespacesAndNewlines)
                .compactMap { line in
                    if let match = line.firstMatch(of: regex),
                       let dir = Dir(rawValue: String(match.output.1)),
                       let clicks = Int(match.output.2) {
                        return Rotation(dir: dir, clicks: clicks)
                    }
                    return nil
                }
        }
    }
    
    func part1() -> Any {
        var password = 0
        var position = 50
        for rotation in Rotation.parse(from: data) {
            switch rotation.dir {
            case .left:
                position -= rotation.clicks
            case .right:
                position += rotation.clicks
            }
            
            while position < 0 {
                position += 100
            }
            while position > 99 {
                position -= 100
            }
            
            if position == 0 {
                password += 1
            }
        }
        
        return password
    }
    
    func part2() -> Any {
        var password = 0
        var position = 50
        for rotation in Rotation.parse(from: data) {
            let move = rotation.dir == .left ? -1 : 1
            for _ in 0..<rotation.clicks {
                position += move
                if position == 100 {
                    position = 0
                }
                else if position == -1 {
                    position = 99
                }
                
                if position == 0 {
                    password += 1
                }
            }
        }
        
        return password
    }
}
