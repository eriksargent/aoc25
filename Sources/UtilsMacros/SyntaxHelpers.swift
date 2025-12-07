//
//  SyntaxHelpers.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/7/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension LabeledExprListSyntax {
    public func expression(named name: String) -> ExprSyntax? {
        first(where: { $0.label?.text == name })?.expression
    }
}


extension StringLiteralExprSyntax {
    public var string: String? {
        guard let segment = self.segments.first,
              case .stringSegment(let stringSegmentSyntax) = segment else {
            return nil
        }
        
        return stringSegmentSyntax.content.text
    }
}
