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
        CodableIgnoreInitializedProperties_Extension.self,
        CodableIgnoreInitializedProperties_Member.self,
        CodableIgnored.self,
    ]
}

enum MacroExpansionError: Error {
    case unsupportedDeclaration
}
