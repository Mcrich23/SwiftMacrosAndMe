//
//  SwiftMacrosAndMePlugin.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//


@main
struct SwiftMacrosAndMePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
    ]
}