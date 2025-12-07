//
//  Macros.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/7/25.
//


@attached(body)
@attached(peer, names: arbitrary)
public macro Memoize() = #externalMacro(module: "UtilsMacros", type: "MemoizeMacro")
