//
//  AccessorMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct CodableIgnored: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        []
    }
}
