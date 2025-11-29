//
//  main.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/2/24.
//

import PackagePlugin
import Foundation

@main
struct Benchmark: CommandPlugin {
    enum BenchmarkError: Error {
        case unableToBuildProduct
        case errorReadingOutput
    }
    
    
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let buildResult = try packageManager.build(.product("AdventOfCode"), parameters: .init(configuration: .release, logging: .concise))
        guard buildResult.succeeded else {
            throw BenchmarkError.unableToBuildProduct
        }
        guard let executable = buildResult.builtArtifacts.first(where : { $0.kind == .executable }) else {
            throw BenchmarkError.unableToBuildProduct
        }
        
        let process = Process()
        process.executableURL = executable.url
        process.arguments = ["--all", "--benchmark"]
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        guard let outputData = try pipe.fileHandleForReading.readToEnd(),
              let output = String(data: outputData, encoding: .utf8) else {
            throw BenchmarkError.errorReadingOutput
        }
        
        let lines = output.components(separatedBy: .newlines)
        guard let start = lines.firstIndex(of: "--- Begin Timings ---"),
              let end = lines.firstIndex(of: "--- End Timings ---") else {
            throw BenchmarkError.errorReadingOutput
        }
        
        let timings = lines[start + 1 ..< end].joined(separator: "\n")
        print(timings)
        
        let readme = "# Advent of Code Swift 24\n\n\(timings)"
        try readme.write(toFile: "README.md", atomically: true, encoding: .utf8)
    }
}
