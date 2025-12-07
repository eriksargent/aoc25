//
//  Memoize.swift
//  AdventOfCode
//
//  Created by Erik Sargent on 12/7/25.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct MemoizeMacro: PeerMacro, BodyMacro {
    enum MacroError: Error, CustomStringConvertible {
        case onlyFunction
        case noReturn
        
        var description: String {
            switch self {
            case .onlyFunction: "@RecursiveMemoize can be attached only to functions."
            case .noReturn: "@RecursiveMemoize is only useful if the function returns something"
            }
        }
    }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
            
            guard let declaration = declaration.as(FunctionDeclSyntax.self) else { throw MacroError.onlyFunction }
            guard let returnClause = declaration.signature.returnClause else { throw MacroError.noReturn }
            
            var declarations: [SwiftSyntax.DeclSyntax] = [
                "private var \(raw: storageName(from: declaration)) = [Int: \(returnClause.type.trimmed)]()"
            ]
            
            let hashFunction = try FunctionDeclSyntax("private func \(raw: hasherName(from: declaration))\(declaration.signature.parameterClause.trimmed) -> Int") {
                "var hasher = Hasher()"
                for parameter in declaration.signature.parameterClause.parameters {
                    "hasher.combine(\(parameter.secondName ?? parameter.firstName))"
                }
                "return hasher.finalize()"
            }
            declarations.append(DeclSyntax(hashFunction))
            
            return declarations
        }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingBodyFor declaration: some SwiftSyntax.DeclSyntaxProtocol & SwiftSyntax.WithOptionalCodeBlockSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.CodeBlockItemSyntax] {
            
            guard let declaration = declaration.as(FunctionDeclSyntax.self), let body = declaration.body else { throw MacroError.onlyFunction }
            
            let internalFunction = try FunctionDeclSyntax("func internalFunction\(declaration.signature.trimmed)") {
                if let body = declaration.body {
                    body.statements
                }
            }
            
            var functionCallSyntax = "("
            for (index, parameter) in declaration.signature.parameterClause.parameters.enumerated() {
                functionCallSyntax.append("\(parameter.firstName.trimmed): \(parameter.secondName ?? parameter.firstName)")
                if index < declaration.signature.parameterClause.parameters.count - 1 {
                    functionCallSyntax.append(", ")
                }
            }
            functionCallSyntax += ")"
            
            var expressions: [SwiftSyntax.CodeBlockItemSyntax] = [
                "func internalFunction\(declaration.signature.trimmed) {",
            ]
            for statement in (internalFunction.body ?? body).statements {
                expressions.append(statement)
            }
            expressions.append(contentsOf: [
                "}",
                "let key = \(raw: hasherName(from: declaration))\(raw: functionCallSyntax)",
                "if let cached = \(raw: storageName(from: declaration))[key] {",
                "    return cached",
                "}",
                "",
                "let result = internalFunction\(raw: functionCallSyntax)",
                "\(raw: storageName(from: declaration))[key] = result",
                "return result"
            ])            
            
            return expressions
        }
    
    static func storageName(from function: FunctionDeclSyntax) -> String {
        return "_" + function.name.text + "Storage"
    }
    
    static func hasherName(from function: FunctionDeclSyntax) -> String {
        return "_make" + function.name.text.prefix(1).uppercased() + function.name.text.dropFirst() + "Hash"
    }
}
