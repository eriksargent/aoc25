//
//  Numeric.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/2/24.
//

import Algorithms


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
    
    /// Performs a filter broken up into chunks and multithreaded. This does not keep a stable order
    public func threadedFilter(_ isIncluded: @Sendable @escaping (Element) -> Bool) async -> [Element] where Element: Sendable {
        return await withTaskGroup { group in
            for chunk in self.evenlyChunked(in: 10) {
                group.addTask {
                    return chunk.filter(isIncluded)
                }
            }
            
            var filtered = [Element]()
            while let next = await group.next() {
                filtered.append(contentsOf: next)
            }
            
            return filtered
        }
    }
    
    /// Performs a map broken up into chunks and multithreaded. This does not keep a stable order
    public func threadedMap<T: Sendable>(_ transform: @Sendable @escaping (Element) -> T) async -> [T] where Element: Sendable {
        return await withTaskGroup { group in
            for chunk in self.evenlyChunked(in: 10) {
                group.addTask {
                    return chunk.map(transform)
                }
            }
            
            var mapped: [T] = []
            while let next = await group.next() {
                mapped.append(contentsOf: next)
            }
            
            return mapped
        }
    }
}
