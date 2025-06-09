// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// A macro that produces an unwrapped URL in case of a valid input URL.
/// For example,
///
///     #URL("https://www.avanderlee.com")
///
/// produces an unwrapped `URL` if the URL is valid. Otherwise, it emits a compile-time error.
///
/// Source: [Antoine van der Lee](https://www.avanderlee.com/swift/macros/)
@freestanding(expression)
public macro URL(_ stringLiteral: String) -> URL = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "URLMacro")

/// A macro that produces code that has a function that decodes a base64 string
///
///     #base64Encoded("food")
///
/// produces an array converted to string: `PrivateObfuscationMacro.base64Decoded("dGVzdA==")`.
@freestanding(expression)
public macro base64Encoded(_ value: String) -> String? = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "Base64ObfuscationMacro")


/// Applies `@Codable` to an object and `@CodableIgnored` to all inline initialized properties.
@attached(member, names: arbitrary)
public macro CodableIgnoreInitializedProperties() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "CodableIgnoreInitializedProperties")

/// Conforms an object to `Codable` and synthesizes `CodingKeys` for it.
@attached(member, names: arbitrary)
@attached(extension, conformances: Codable, names: arbitrary)
public macro Codable() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "Codable")

/// Tells `@Codable` to exclude a property from the `CodingKeys`.
@attached(peer)
public macro CodableIgnored() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "CodableIgnored")

/// Make any async/await function also available for a synchronous context with just one line!
@attached(peer, names: overloaded)
public macro AddSynchronous() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "AddSynchronous")

/// Securely save and read from the Keychain without all of the boiler plate each time.
@attached(accessor)
public macro SecureStorage(_ key: String) = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "SecureStorage")

