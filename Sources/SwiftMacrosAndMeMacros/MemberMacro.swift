//
//  MemberMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct CodableIgnoreInitializedProperties_Member: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
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
