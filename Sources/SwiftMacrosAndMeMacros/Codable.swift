//
//  MemberMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

/// Conforms an object to `Codable` and synthesizes `CodingKeys` for it.
public struct Codable: MemberMacro, MemberAttributeMacro, ExtensionMacro {
    static let messageId = "Codable"
    
    /// MemberAttributeMacro Expansion
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingAttributesFor member: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.AttributeSyntax] {
        guard let property = member.as (VariableDeclSyntax.self),
              !(property.bindings.first?.initializer == nil && property.bindings.first?.accessorBlock == nil),
              !property.attributes.contains(where: { $0.trimmedDescription == "@CodableIgnored" }),
              property.bindingSpecifier.trimmedDescription == "let"
        else {
            return []
        }
        
        let oldNode = property.bindingSpecifier
        let newNode = DeclSyntax(stringLiteral: "@CodableIgnored \(oldNode.trimmedDescription)")
        
        let diagnosticMessage = WarningMessage(message: "Immutable property will not be decoded because it is declared with an initial value which cannot be overwritten", id: messageId)
        let fixItMessage = FixItMessageStruct(message: "Ignore the property when encoding/decoding", id: messageId)
        
        let fixIt = FixIt.replace(message: fixItMessage, oldNode: oldNode, newNode: newNode)
        context.diagnose(.init(node: Syntax(property), message: diagnosticMessage, fixIt: fixIt))
        
        return []
    }
    
    /// ExtensionMacro Expansion
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        let protocols = protocols.map({ $0.trimmedDescription })
        guard !protocols.isEmpty else {
            return []
        }
        
        let extensionSyntax = try ExtensionDeclSyntax("extension \(type.trimmed): \(raw: protocols.joined(separator: ", ")) {}")
        return [extensionSyntax]
    }
    
    /// MemberMacro Expansion
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        let existingEnums = structDecl.memberBlock.members.compactMap {
            $0.decl.as(EnumDeclSyntax.self)
        }

        let hasCodingKeys = existingEnums.contains { decl in
            decl.name.text == "CodingKeys"
        }
        guard !hasCodingKeys else {
            throw "Coding keys already exist."
        }

        let properties = structDecl.memberBlock.members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        
        let nonIgnoredProperties = properties.filter({ property in
            !property.attributes.contains { attribute in
                guard let syntax = attribute.as(AttributeSyntax.self) else { return true }
                
                return syntax.attributeName.trimmedDescription == "CodableIgnored"
            }
        })
        
        let enumCases: [String] = nonIgnoredProperties.compactMap { decl in
            guard let name = decl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
                  
            else {
                return nil
            }
            
            return "case \(name)"
        }

        guard !enumCases.isEmpty else {
            return []
        }

        let codingKeysEnum = """
        enum CodingKeys: String, CodingKey {
            \(enumCases.joined(separator: "\n"))
        }
        """

        return [.init(stringLiteral: codingKeysEnum)]
    }
}
