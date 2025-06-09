//
//  SwiftMacrosAndMePlugin.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros
import SwiftDiagnostics

@main
struct SwiftMacrosAndMePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
        Base64ObfuscationMacro.self,
        CodableIgnoreInitializedProperties.self,
        Codable.self,
        CodableIgnored.self,
        SecureStorage.self,
        AddSynchronous.self,
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

/// Diagnostic message for warnings
struct WarningMessage: DiagnosticMessage {
    let message: String
    let id: String
    let severity: DiagnosticSeverity = .warning
    
    var diagnosticID: MessageID {
        .init(domain: "SwiftMacrosAndMe", id: id)
    }
    
    var fixItMessage: FixItMessageStruct {
        FixItMessageStruct(message: message, id: id)
    }
}

struct FixItMessageStruct: FixItMessage {
    var message: String
    let id: String
    
    var fixItID: MessageID {
        .init(domain: "SwiftMacrosAndMe", id: id)
    }
}
