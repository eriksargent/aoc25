//
//  MacroPlugin.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/7/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


@main
struct UtilsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MemoizeMacro.self
    ]
}
