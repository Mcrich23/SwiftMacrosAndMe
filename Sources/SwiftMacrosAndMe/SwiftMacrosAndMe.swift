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

@attached(extension, conformances: Decodable, names: arbitrary)
public macro CodableIgnoreInitializedProperties_Extension() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "CodableIgnoreInitializedProperties_Extension")

@attached(member, names: arbitrary)
public macro CodableIgnoreInitializedProperties_Member() = #externalMacro(module: "SwiftMacrosAndMeMacros", type: "CodableIgnoreInitializedProperties_Member")
