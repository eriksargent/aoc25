//
//  Numeric.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/2/24.
//


extension Array where Element: Numeric {
    public func sum() -> Element {
        return self.reduce(0, +)
    }
}


extension Array {
    public func removing(at index: Int) -> Self {
        var copy = self
        copy.remove(at: index)
        return copy
    }
}
