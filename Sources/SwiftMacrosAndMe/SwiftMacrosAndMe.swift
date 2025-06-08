// The Swift Programming Language
// https://docs.swift.org/swift-book

import KeychainSwift

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "StringifyMacro")

@attached(member, names: arbitrary)
@attached(extension, conformances: Codable, names: arbitrary)
@attached(memberAttribute)
public macro CodableIgnoreInitializedProperties() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "CodableIgnoreInitializedProperties")

@attached(member, names: arbitrary)
@attached(extension, conformances: Codable, names: arbitrary)
public macro Codable() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "Codable")

@attached(peer)
public macro CodableIgnored() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "CodableIgnored")

@attached(accessor)
public macro SecureStorage(_ key: String) = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "SecureStorage")
