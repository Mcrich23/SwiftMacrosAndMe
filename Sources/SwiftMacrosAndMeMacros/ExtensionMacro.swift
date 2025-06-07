//
//  ExtensionMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct CodableIgnoreInitializedProperties_Extension: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        let existingInits = structDecl.memberBlock.members.compactMap {
            $0.decl.as(InitializerDeclSyntax.self)
        }

        let hasFromDecoderInit = existingInits.contains { initDecl in
            guard let firstParam = initDecl.signature.parameterClause.parameters.first else { return false }
            return firstParam.firstName.text == "decoder" &&
                   firstParam.type.description.contains("Decoder")
        }

        let properties = structDecl.memberBlock.members.compactMap { $0.decl.as(VariableDeclSyntax.self) }

        let initEligibleProperties = properties.filter { prop in
            guard let binding = prop.bindings.first else { return false }
            return binding.initializer == nil && binding.accessorBlock == nil
        }

        let decodeInitBody = initEligibleProperties.compactMap { property in
            guard let name = property.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                  let type = property.bindings.first?.typeAnnotation?.type.description else {
                return nil
            }

            if type.hasSuffix("?") {
                return "self.\(name) = try container.decodeIfPresent(\(type.dropLast()).self, forKey: .\(name))"
            } else {
                return "self.\(name) = try container.decode(\(type).self, forKey: .\(name))"
            }
        }.joined(separator: "\n")

        guard !decodeInitBody.isEmpty, !hasFromDecoderInit else {
            return []
        }

        let decodeInit = """
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            \(decodeInitBody)
        }
        """

        let extensionSyntax = try ExtensionDeclSyntax("extension \(type.trimmed) {\n\(raw: decodeInit)\n}")

        return [extensionSyntax]
    }
}
