import Foundation
import Algorithms

import Utils


struct Day11: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    private final class DeviceHandler {
        var deviceMap: [String: Device]
        
        init(data: String) {
            deviceMap = data
                .components(separatedBy: .newlines)
                .filter({ !$0.isEmpty })
                .compactMap({ Device(from: $0) })
                .reduce(into: [:], { $0[$1.name] = $1 })
        }
        
        struct Device {
            var name: String
            var outputs: [String]
            
            init?(from string: String) {
                let components = string.components(separatedBy: ":")
                guard components.count == 2 else { return nil }
                self.name = components[0]
                self.outputs = components[1].trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces)
            }
        }
        
        func pathsToOut(from: String) -> Int {
            guard let device = deviceMap[from], !device.outputs.isEmpty else { return 0 }
            
            if device.outputs.contains("out") {
                return 1
            }
            
            return device.outputs.map { pathsToOut(from: $0) }.sum()
        }
        
        @Memoize
        func pathsToOut2(from: String, foundFFT: Bool, foundDAC: Bool) -> Int {
            guard let device = deviceMap[from], !device.outputs.isEmpty else { return 0 }
            
            if device.outputs.contains("out") {
                if foundFFT && foundDAC {
                    return 1
                }
                else {
                    return 0
                }
            }
            
            let foundFFT = foundFFT || (from == "fft")
            let foundDAC = foundDAC || (from == "dac")
            
            return device.outputs.map { pathsToOut2(from: $0, foundFFT: foundFFT, foundDAC: foundDAC) }.sum()
        }
    }
    
    func part1() -> Any {
        return DeviceHandler(data: data).pathsToOut(from: "you")
    }
    
    func part2() -> Any {
        return DeviceHandler(data: data).pathsToOut2(from: "svr", foundFFT: false, foundDAC: false)
    }
}
