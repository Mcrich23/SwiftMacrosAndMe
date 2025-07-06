//
//  PeerMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

/// Make any async/await function also available for a synchronous context with just one line!
public struct AddSynchronous: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let syntax = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        let returnType: String = "\(syntax.signature.returnClause?.trimmedDescription.dropFirst(3) ?? "Void")"
        let isThrowing = syntax.signature.effectSpecifiers?.throwsClause != nil
        
        if returnType == "Void" {
            switch isThrowing {
            case false: return try handleAsyncVoid(of: node, providingPeersOf: declaration, in: context)
            case true: return try handleAsyncThrowsVoid(of: node, providingPeersOf: declaration, in: context)
            }
        } else {
            switch isThrowing {
            case false: return try handleAsyncNonVoid(of: node, providingPeersOf: declaration, in: context)
            case true: return try handleAsyncThrowsNonVoid(of: node, providingPeersOf: declaration, in: context)
            }
        }
    }
    
    // MARK: Non-Void Handlers
    private static func handleAsyncNonVoid(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let syntax = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        guard let returnType = syntax.signature.returnClause?.trimmedDescription.dropFirst(3) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        let functionModifiers = (syntax.modifiers.description + " nonisolated").trimmingCharacters(in: .whitespacesAndNewlines)
        let functionName = syntax.name.text
        let functionParameters = syntax.signature.parameterClause.parameters.map({ $0.description }) + ["completion: (@Sendable (\(returnType)) -> Void)? = nil"]
        let passthroughParameters = syntax.signature.parameterClause.parameters.map({ "\($0.firstName): \($0.secondName ?? $0.firstName)" })
        
        let functionBody = """
            Task {
                let value = await \(functionName)(\(passthroughParameters.joined(separator: ",")))
                completion?(value)
            }
            """
        
        let function = try DeclSyntax(validating: .init(stringLiteral: "\(functionModifiers) func \(functionName)(\(functionParameters.joined(separator: ", "))) {\(functionBody)}"))
        
        return [function]
    }
    
    private static func handleAsyncThrowsNonVoid(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let syntax = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        guard let returnType = syntax.signature.returnClause?.trimmedDescription.dropFirst(3) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        let functionModifiers = (syntax.modifiers.description + " nonisolated").trimmingCharacters(in: .whitespacesAndNewlines)
        let functionName = syntax.name.text
        
        let completion: String = if returnType.contains("?") {
            "completion: (@Sendable (\(returnType), Error?) -> Void)? = nil"
        } else {
            "completion: (@Sendable (\(returnType)?, Error?) -> Void)? = nil"
        }
        
        let functionParameters = syntax.signature.parameterClause.parameters.map({ $0.description }) + [completion]
        let passthroughParameters = syntax.signature.parameterClause.parameters.map({ "\($0.firstName): \($0.secondName ?? $0.firstName)" })
        
        let functionBody = """
            Task {
                do {
                    let value = try await \(functionName)(\(passthroughParameters.joined(separator: ",")))
                    completion?(value, nil)
                } catch {
                    completion?(nil, error)
                }
            }
            """
        
        let function = try DeclSyntax(validating: .init(stringLiteral: "\(functionModifiers) func \(functionName)(\(functionParameters.joined(separator: ", "))) {\(functionBody)}"))
        
        return [function]
    }
    
    // MARK: Void Handlers
    private static func handleAsyncVoid(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let syntax = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        let functionModifiers = (syntax.modifiers.description + " nonisolated").trimmingCharacters(in: .whitespacesAndNewlines)
        let functionName = syntax.name.text
        let functionParameters = syntax.signature.parameterClause.parameters.map({ $0.description }) + ["completion: (@Sendable () -> Void)? = nil"]
        let passthroughParameters = syntax.signature.parameterClause.parameters.map({ "\($0.firstName): \($0.secondName ?? $0.firstName)" })
        
        let functionBody = """
            Task {
                await \(functionName)(\(passthroughParameters.joined(separator: ",")))
                completion?()
            }
            """
        
        let function = try DeclSyntax(validating: .init(stringLiteral: "\(functionModifiers) func \(functionName)(\(functionParameters.joined(separator: ", "))) {\(functionBody)}"))
        
        return [function]
    }
    
    private static func handleAsyncThrowsVoid(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let syntax = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        let functionModifiers = (syntax.modifiers.description + " nonisolated").trimmingCharacters(in: .whitespacesAndNewlines)
        let functionName = syntax.name.text
        let functionParameters = syntax.signature.parameterClause.parameters.map({ $0.description }) + ["completion: (@Sendable (Error?) -> Void)? = nil"]
        let passthroughParameters = syntax.signature.parameterClause.parameters.map({ "\($0.firstName): \($0.secondName ?? $0.firstName)" })
        
        let functionBody = """
            Task {
                do {
                    try await \(functionName)(\(passthroughParameters.joined(separator: ",")))
                    completion?(nil)
                } catch {
                    completion?(error)
                }
            }
            """
        
        let function = try DeclSyntax(validating: .init(stringLiteral: "\(functionModifiers) func \(functionName)(\(functionParameters.joined(separator: ", "))) {\(functionBody)}"))
        
        return [function]
    }
}
