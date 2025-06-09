//
//  CodableIgnored.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/8/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

/// Tells `@Codable` to exclude a property from the `CodingKeys`.
public struct CodableIgnored: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        []
    }
}
