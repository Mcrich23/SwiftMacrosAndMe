//
//  Base64ObfuscationMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/8/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

/// A macro that produces code that has a function that decodes a base64 string
///
///     #base64Encoded("food")
///
/// produces an array converted to string: `PrivateObfuscationMacro.base64Decoded("dGVzdA==")`.
public struct Base64ObfuscationMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        // Ensure the argument is a string literal
        guard let stringLiteral = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
              let text = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
        else {
            throw "compiler bug: Expected a string literal"
        }

        // Convert to Base64
        guard let data = text.data(using: .utf8) else {
            throw "compiler bug: Data conversion failed"
        }

        return "SwiftMacrosAndMe.base64Decoded(\"\(raw: data.base64EncodedString())\")"
    }
}
