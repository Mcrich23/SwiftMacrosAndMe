//
//  CodableIgnoreInitializedProperties.swift
//  EnhancedCodable
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct CodableIgnoreInitializedProperties: MemberAttributeMacro, MemberMacro, ExtensionMacro {
    
    /// ExtensionMacro Expansion
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        try Codable.expansion(of: node, attachedTo: declaration, providingExtensionsOf: type, conformingTo: protocols, in: context)
    }
    
    /// MemberMacro Expansion
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        try Codable.expansion(of: node, providingMembersOf: declaration, conformingTo: protocols, in: context)
    }
    
    /// MemberAttributeMacro Extension
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingAttributesFor member: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AttributeSyntax] {
        guard let property = member.as (VariableDeclSyntax.self),
              !(property.bindings.first?.initializer == nil && property.bindings.first?.accessorBlock == nil)
        else {
            return []
        }
        
        return [
            .init(stringLiteral: "@CodableIgnored")
        ]
    }
}
