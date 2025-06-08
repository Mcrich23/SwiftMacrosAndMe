//
//  AccessorMacro.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/7/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import KeychainSwift

public struct SecureStorage: AccessorMacro {
    public static func expansion(of node: AttributeSyntax, providingAccessorsOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AccessorDeclSyntax] {
        guard let key = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        guard let syntax = declaration.as(VariableDeclSyntax.self),
              let type = syntax.bindings.first?.typeAnnotation?.type.trimmedDescription.replacingOccurrences(of: "?", with: "")
        else {
            throw MacroExpansionError.unsupportedDeclaration
        }
        
        var getFunctionName = switch type {
        case "String": "get"
        case "Bool": "getBool"
        case "Data": "getData"
        default: "get"
        }
        
        return [
            """
            get {
                let keychain = KeychainSwift()
                return keychain.\(raw: getFunctionName)(\(key))
            }
            """,
            """
            set {
                let keychain = KeychainSwift()
                guard let newValue else {
                    keychain.delete(\(key))
                    return
                }
                
                keychain.set(newValue, forKey: \(key), withAccess: nil)
            }
            """
        ]
    }
}
//
///// A property wrapper to easily and securely save data in Keychain
//@propertyWrapper
//public struct SecureStorage<T: ExpressibleByNilLiteral> {
//    /// The key for the value in keychain
//    let key: String
//    /// The `KeychainSwift` being saved with
//    var keychain: KeychainSwift
//    /// Access controls for keychain
//    var access: KeychainSwiftAccessOptions?
//    
//    /// The underlying get function for wrappedValue
//    /// - Returns: `T`
//    let _get: () -> T
//    /// The underlying set function for wrappedValue
//    /// - Parameters:
//    ///   - `T`: The new value being set
//    let _set: (T) -> Void
//    
//    public var wrappedValue: T {
//        get {
//            _get()
//        }
//        set {
//            _set(newValue)
//        }
//    }
//    
//    /// The Initializer for `SecureStorage`
//    /// - Parameters:
//    ///   - key: The key for the value in keychain
//    ///   - keychain: The `KeychainSwift` being saved with
//    ///   - access: Access controls for keychain
//    public init(
//        _ key: String,
//        keychain: KeychainSwift = SecureStorageDefaults.keychain,
//        withAccess access: KeychainSwiftAccessOptions? = SecureStorageDefaults.access
//    ) {
//        self.key = key
//        self.keychain = keychain
//        self.access = access
//        
//        self._get = { nil }
//        self._set = { _ in fatalError("Unsupported Type") }
//    }
//}
//
//// MARK: Support String
//extension SecureStorage where T == Optional<String> {
//    /// The Initializer for `SecureStorage`
//    /// - Parameters:
//    ///   - key: The key for the value in keychain
//    ///   - keychain: The `KeychainSwift` being saved with
//    ///   - access: Access controls for keychain
//    public init(
//        _ key: String,
//        keychain: KeychainSwift = SecureStorageDefaults.keychain,
//        withAccess access: KeychainSwiftAccessOptions? = SecureStorageDefaults.access
//    ) {
//        self.key = key
//        self.keychain = keychain
//        self.access = access
//        
//        self._get = {
//            keychain.get(key)
//        }
//        self._set = { newValue in
//            guard let newValue else {
//                keychain.delete(key)
//                return
//            }
//            
//            keychain.set(newValue, forKey: key, withAccess: access)
//        }
//    }
//}
//
//// MARK: Support Bool
//extension SecureStorage where T == Optional<Bool> {
//    /// The Initializer for `SecureStorage`
//    /// - Parameters:
//    ///   - key: The key for the value in keychain
//    ///   - keychain: The `KeychainSwift` being saved with
//    ///   - access: Access controls for keychain
//    public init(
//        _ key: String,
//        keychain: KeychainSwift = SecureStorageDefaults.keychain,
//        withAccess access: KeychainSwiftAccessOptions? = SecureStorageDefaults.access
//    ) {
//        self.key = key
//        self.keychain = keychain
//        self.access = access
//        
//        self._get = {
//            keychain.getBool(key)
//        }
//        self._set = { newValue in
//            guard let newValue else {
//                keychain.delete(key)
//                return
//            }
//            
//            keychain.set(newValue, forKey: key, withAccess: access)
//        }
//    }
//}
//
//// MARK: Support Data
//extension SecureStorage where T == Optional<Data> {
//    /// The Initializer for `SecureStorage`
//    /// - Parameters:
//    ///   - key: The key for the value in keychain
//    ///   - keychain: The `KeychainSwift` being saved with
//    ///   - access: Access controls for keychain
//    public init(
//        _ key: String,
//        keychain: KeychainSwift = SecureStorageDefaults.keychain,
//        withAccess access: KeychainSwiftAccessOptions? = SecureStorageDefaults.access
//    ) {
//        self.key = key
//        self.keychain = keychain
//        self.access = access
//        
//        self._get = {
//            keychain.getData(key)
//        }
//        self._set = { newValue in
//            guard let newValue else {
//                keychain.delete(key)
//                return
//            }
//            
//            keychain.set(newValue, forKey: key, withAccess: access)
//        }
//    }
//}
