//
//  Memoize.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/11/24.
//


// https://www.hackingwithswift.com/plus/high-performance-apps/using-memoization-to-speed-up-slow-functions
func memoize<Input: Hashable, Output>(_ function: @escaping (Input) -> Output) -> (Input) -> Output {
    // our item cache
    var storage = [Input: Output]()
    
    // send back a new closure that does our calculation
    return { input in
        if let cached = storage[input] {
            return cached
        }
        
        let result = function(input)
        storage[input] = result
        return result
    }
}

func recursiveMemoize<Input: Hashable, Output>(_ function: @escaping ((Input) -> Output, Input) -> Output) -> (Input) -> Output {
    // our item cache
    var storage = [Input: Output]()
    
    // send back a new closure that does our calculation
    var memo: ((Input) -> Output)!
    
    memo = { input in
        if let cached = storage[input] {
            return cached
        }
        
        let result = function(memo, input)
        storage[input] = result
        return result
    }
    
    return memo
}
