//
//  SwiftMacrosAndMePlugin.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftMacrosAndMePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        CodableIgnoreInitializedProperties.self,
        Codable.self,
        CodableIgnored.self,
    ]
}

enum MacroExpansionError: Error {
    case unsupportedDeclaration
    case codingKeysAlreadyExist
    
    var localizedDescription: String {
        switch self {
        case .unsupportedDeclaration:
            return "Unsupported declaration for macro expansion."
        case .codingKeysAlreadyExist:
            return "Coding keys already exist."
        }
    }
}

extension String: @retroactive Error {
}
