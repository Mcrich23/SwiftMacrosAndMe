//
//  AccessorMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import KeychainSwift

/// Securely save and read from the Keychain without all of the boiler plate each time.
public struct SecureStorage: AccessorMacro {
    public static func expansion(of node: AttributeSyntax, providingAccessorsOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AccessorDeclSyntax] {
        guard case .argumentList(let args) = node.arguments,
              let key = args.first?.expression.trimmedDescription
        else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        let keychain: String
        
        if let keychainDescription = args.last?.expression.trimmedDescription, keychainDescription != key {
            keychain = keychainDescription
        } else {
            keychain = "KeychainSwift.shared"
        }
        
        guard let syntax = declaration.as(VariableDeclSyntax.self),
              let type = syntax.bindings.first?.typeAnnotation?.type.trimmedDescription.replacingOccurrences(of: "?", with: "")
        else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        let getFunctionName = switch type {
        case "String": "get"
        case "Bool": "getBool"
        case "Data": "getData"
        default: "get"
        }
        
        return [
            """
            get {
                let keychain: KeychainSwift = \(raw: keychain)
                return keychain.\(raw: getFunctionName)(\(raw: key))
            }
            """,
            """
            set {
                let keychain = KeychainSwift.shared
                guard let newValue else {
                    keychain.delete(\(raw: key))
                    return
                }
                
                keychain.set(newValue, forKey: \(raw: key), withAccess: nil)
            }
            """
        ]
    }
}
