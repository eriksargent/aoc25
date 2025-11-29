//
//  main.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/2/24.
//


import PackagePlugin
import Foundation

@main
struct AddDay: CommandPlugin {
    
    enum ProcessError: Error {
        case unableToFindTemplate
    }
    
    func performCommand(context: PluginContext, arguments: [String]) throws {
        print(context.package.directoryURL)
        
        let dataPath = context.package.directoryURL.appending(path: "Sources/Data")
        let sourcePath = context.package.directoryURL.appending(path: "Sources")
        let testPath = context.package.directoryURL.appending(path: "Tests")
        
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: dataPath.path),
              let lastDay = files.map({ $0.trimmingCharacters(in: .decimalDigits.inverted) }).compactMap(Int.init).max() else {
            throw ProcessError.unableToFindTemplate
        }
        
        let nextDay = lastDay + 1
        let nextName = String(format: "Day%02d", nextDay)
        print("Setting up \(nextName)")
        
        guard let dataTemplate = try? String.init(contentsOfFile: dataPath.appending(path: "Day00.txt").path, encoding: .utf8),
              let sourceTemplate = try? String.init(contentsOfFile: sourcePath.appending(path: "Day00.swift").path, encoding: .utf8),
              let testTemplate = try? String.init(contentsOfFile: testPath.appending(path: "Day00Tests.swift").path, encoding: .utf8) else {
            throw ProcessError.unableToFindTemplate
        }
        
        FileManager.default.createFile(atPath: dataPath.appending(path: "\(nextName).txt").path, contents: dataTemplate.data(using: .utf8), attributes: nil)
        
        let source = sourceTemplate.replacingOccurrences(of: "Day00", with: nextName)
        let test = testTemplate.replacingOccurrences(of: "Day00", with: nextName)
        
        FileManager.default.createFile(atPath: sourcePath.appending(path: "\(nextName).swift").path, contents: source.data(using: .utf8), attributes: nil)
        FileManager.default.createFile(atPath: testPath.appending(path: "\(nextName)Tests.swift").path, contents: test.data(using: .utf8), attributes: nil)
        
        let manifestPath = context.package.directoryURL.appending(path: "Sources/AdventOfCode.swift")
        guard var manifest = try? String.init(contentsOfFile: manifestPath.path, encoding: .utf8).components(separatedBy: .newlines),
              let index = manifest.firstIndex(of: "] // END DAYS") else {
            throw ProcessError.unableToFindTemplate
        }
        
        manifest.insert("    \(nextName)(),", at: index)
        
        let newManifest = manifest.joined(separator: "\n")
        try newManifest.write(to: manifestPath, atomically: true, encoding: .utf8)
    }
}
