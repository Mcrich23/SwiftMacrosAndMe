// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "StringifyMacro")

/// Applies `@Codable` to an object and `@CodableIgnored` to all inline initialized properties.
@attached(member, names: arbitrary)
@attached(extension, conformances: Codable, names: arbitrary)
@attached(memberAttribute)
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
