# SwiftMacrosAndMe

As seen in the talk I debuted on June 13th 2025, here are some macros I built/found that are making my developer experience more efficient.

## Usage

This package provides a suite of Swift macros to simplify common coding patterns. Below are the available macros and example usage:

> **Note:** If you would like to try the codable macros I am showcasing here, you can use my dedicated macro package for it: [EnhancedCodable](https://github.com/Mcrich23/EnhancedCodable).

### 1. `@Codable`
Conforms a struct or class to `Codable` and synthesizes `CodingKeys`.

```swift
@Codable
struct Foo: Codable {
    var bar: Int
    let baz: String
}
```

### 2. `@CodableIgnoreInitializedProperties`
Applies `@Codable` and automatically ignores all inline-initialized properties (they won’t be encoded/decoded).

```swift
@CodableIgnoreInitializedProperties
struct Bar {
    let id = UUID() // This property will be ignored for Codable
    var value: String
}
```

### 3. `@CodableIgnored`
Exclude a property from the synthesized `CodingKeys` (to not encode/decode it).

```swift
@Codable
struct Baz {
    var visible: String
    @CodableIgnored var hidden: String // will not be encoded/decoded
}
```

### 4. `@AddSynchronous`
Automatically generate a synchronous version (with a completion handler) of an async function.

```swift
@AddSynchronous
func fetchData() async throws -> Data {
    // ...
}

// Synchronous usage:
fetchData { data, error in
    // Handle result
}
```

### 5. `@SecureStorage`
Easily read and write to the Keychain with property wrappers.

```swift
@SecureStorage("user_token") var token: String?
token = "mySecret"
```

### 6. `#URL`
Compile-time checked URL literal. Fails to compile if the string is not a valid URL.

```swift
let url = #URL("https://example.com")
```

Credit: [Antoine van der Lee](https://www.avanderlee.com/swift/macros/)

### 7. `#base64Encoded`
Obfuscate a string at compile time by encoding it to base64.

> If you would like to use `#base64Encoded` and other obfuscation macros I have made, try [PrivateObfuscationMacro](https://github.com/Mcrich23/PrivateObfuscationMacro).

```swift
let encoded = #base64Encoded("Hello, World!") // e.g., "SGVsbG8sIFdvcmxkIQ=="
```
