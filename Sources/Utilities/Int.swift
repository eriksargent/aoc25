//
//  Int.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/11/24.
//


// https://stackoverflow.com/questions/24196689/how-to-get-the-power-of-some-integer-in-swift-language
func pow<T: BinaryInteger>(_ base: T, _ power: T) -> T {
    func expBySq(_ y: T, _ x: T, _ n: T) -> T {
        precondition(n >= 0)
        if n == 0 {
            return y
        } else if n == 1 {
            return y * x
        } else if n.isMultiple(of: 2) {
            return expBySq(y, x * x, n / 2)
        } else { // n is odd
            return expBySq(y * x, x * x, (n - 1) / 2)
        }
    }
    
    return expBySq(1, base, power)
}



extension BinaryInteger {
    var isEven: Bool {
        self % 2 == 0
    }
    
    var numberOfDigits: Self {
        var count = 0 as Self
        var value = self
        
        while value != 0 {
            value = value / 10
            count += 1
        }
        
        return count
    }
}
