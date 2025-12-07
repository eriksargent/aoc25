// swift-tools-version: 6.2
import PackageDescription
import CompilerPluginSupport


let dependencies: [Target.Dependency] = [
    .product(name: "Algorithms", package: "swift-algorithms"),
    .product(name: "Collections", package: "swift-collections"),
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
]

let package = Package(
    name: "AdventOfCode",
	platforms: [.macOS(.v26)],
    dependencies: [
		.package(
			url: "https://github.com/apple/swift-algorithms.git",
			.upToNextMajor(from: "1.2.1")),
		.package(
			url: "https://github.com/apple/swift-collections.git",
			.upToNextMajor(from: "1.3.0")),
		.package(
			url: "https://github.com/apple/swift-argument-parser.git",
			.upToNextMajor(from: "1.6.2")),
		.package(
			url: "https://github.com/swiftlang/swift-format.git",
			.upToNextMajor(from: "602.0.0")),
		.package(
			url: "https://github.com/swiftlang/swift-syntax.git",
			.upToNextMajor(from: "602.0.0"))
    ],
    targets: [
        .macro(
            name: "UtilsMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        
        .target(name: "Utils", dependencies: ["UtilsMacros"]),
        .executableTarget(
            name: "AdventOfCode",
            dependencies: ["Utils"] + dependencies,
            resources: [.copy("Data")]
        ),
        
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: [
                "AdventOfCode", "UtilsMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ] + dependencies
        ),
        
        .plugin(
            name: "AddDay",
            capability: .command(
                intent: .custom(verb: "add-day", description: "Add the next AOC day"),
                permissions: [
                    .writeToPackageDirectory(reason: "Adds the next AOC day to the local package")
                ]),
            dependencies: []
        ),
        .plugin(name: "Benchmark", capability: .command(
            intent: .custom(verb: "benchmark", description: "Run benchmarks for the AOC days"),
            permissions: [
                .writeToPackageDirectory(reason: "Updates readme with the new benchmarks")
            ]),
            dependencies: []
        ),
    ],
    swiftLanguageModes: [.v6]
)
