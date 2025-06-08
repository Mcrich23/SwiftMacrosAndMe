import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// A macro that produces an unwrapped URL in case of a valid input URL.
/// For example,
///
///     #URL("https://www.avanderlee.com")
///
/// produces an unwrapped `URL` if the URL is valid. Otherwise, it emits a compile-time error.
///
/// Source: [Antoine van der Lee](https://www.avanderlee.com/swift/macros/)
public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            /// 1. Grab the first (and only) Macro argument.
            let argument = node.arguments.first?.expression,
            /// 2. Ensure the argument contains of a single String literal segment.
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            /// 3. Grab the actual String literal segment.
            case .stringSegment(let literalSegment)? = segments.first
        else {
            throw URLMacroError.requiresStaticStringLiteral
        }

        /// 4. Validate whether the String literal matches a valid URL structure.
        guard let _ = URL(string: literalSegment.content.text) else {
            throw URLMacroError.malformedURL(urlString: "\(argument)")
        }

        return "URL(string: \(argument))!"
    }
}

enum URLMacroError: Error, CustomStringConvertible {
    case requiresStaticStringLiteral
    case malformedURL(urlString: String)

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            return "#URL requires a static string literal"
        case .malformedURL(let urlString):
            return "The input URL is malformed: \(urlString)"
        }
    }
}

/// A macro that produces code that has a function that decodes a base64 string
///
///     #base64Encoded("food")
///
/// produces an array converted to string: `PrivateObfuscationMacro.base64Decoded("dGVzdA==")`.
public struct Base64ObfuscationMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        // Ensure the argument is a string literal
        guard let stringLiteral = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
              let text = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
        else {
            fatalError("compiler bug: Expected a string literal")
        }

        // Convert to Base64
        guard let data = text.data(using: .utf8) else {
            fatalError("compiler bug: Data conversion failed")
        }

        return "SwiftMacrosAndMe.base64Decoded(\"\(raw: data.base64EncodedString())\")"
    }
}
