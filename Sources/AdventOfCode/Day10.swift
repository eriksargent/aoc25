import Foundation
import Algorithms
import RegexBuilder

import Utils


struct Day10: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    struct Machine {
        var targetLight: UInt16
        var switches: [UInt16]
        var joltageSwitches: [UInt128]
        var targetJoltage: UInt128
        
        init?(from string: String) {
            guard let lightsString = string.firstMatch(of: /\[([\.#]+)\]/)?.output.1 else { return nil }
            
            let lights = lightsString.map { $0 == "#" }
            
            var switches = [[Int]]()
            for switchString in string.matches(of: /\(((?:\d+,)*\d+)\)/) {
                switches.append(switchString.output.1.components(separatedBy: .punctuationCharacters).compactMap(Int.init))
            }
            
            guard let joltages = string.firstMatch(of: /\{((?:\d+,)*\d+)\}/)?.output.1.components(separatedBy: .punctuationCharacters).compactMap(UInt128.init) else { return nil }
            
            var lightData: UInt16 = 0
            for value in lights {
                lightData <<= 1
                if value {
                    lightData |= 1
                }
            }
            self.targetLight = lightData
            
            var switchesData = [UInt16]()
            var joltageSwitchesData = [UInt128]()
            for switchOptions in switches {
                var switchData: UInt16 = 0
                var joltageData: UInt128 = 0
                for index in switchOptions {
                    switchData |= 1 << (lights.count - index - 1)
                    joltageData |= 1 << ((lights.count - index - 1) * 8)
                }
                switchesData.append(switchData)
                joltageSwitchesData.append(joltageData)
            }
            
            self.switches = switchesData
            self.joltageSwitches = joltageSwitchesData
            
            var joltageData: UInt128 = 0
            for option in joltages {
                joltageData <<= 8
                joltageData |= option
            }
            self.targetJoltage = joltageData
        }
        
        func getMinToggles() -> Int {
            var searchQueue = switches.map { (1, $0) }
            var noList = Set<UInt16>()
            
            while let (presses, switches) = searchQueue.popFirst() {
                if switches == targetLight {
                    return presses
                }
                
                if noList.contains(switches) {
                    continue
                }
                noList.insert(switches)
                let newSearches = self.switches
                    .map { switches ^ $0 }
                    .filter { !noList.contains($0) }
                searchQueue.append(contentsOf: newSearches.map { (presses + 1, $0) })
            }
            
            return -1
        }
        
        func getMinJoltagePresses() -> Int {
            var searchQueue: [(Int, UInt128)] = [(0, 0)]
            var noList = Set<UInt128>()
            var queuedValueList = Set<UInt128>([0])
            
            while let (presses, switches) = searchQueue.popFirst() {
                queuedValueList.remove(switches)
                if noList.contains(switches) {
                    continue
                }
                noList.insert(switches)
                
                for nextButton in self.joltageSwitches {
                    let next = nextButton + switches
                    if next == targetJoltage {
                        print("Found it 2!")
                        return presses + 1
                    }
                    else if next > targetJoltage {
                        continue
                    }
                    else if !noList.contains(next) && !queuedValueList.contains(next) {
                        queuedValueList.insert(next)
                        searchQueue.append((presses + 1, next))
                    }
                }
            }
            
            return -1
        }
    }
    
    func part1() async -> Any {
        let machines = data.components(separatedBy: .newlines).filter({ !$0.isEmpty }).compactMap({ Machine(from: $0) })
        
        return await machines.threadedMap({ $0.getMinToggles() }).sum()
    }
    
    func part2() -> Any {
        let machines = data.components(separatedBy: .newlines).filter({ !$0.isEmpty }).compactMap({ Machine(from: $0) })
        return 0
//        return await machines.threadedMap({ $0.getMinJoltagePresses() }).sum()
    }
}
