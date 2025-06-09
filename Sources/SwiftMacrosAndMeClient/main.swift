import SwiftMacrosAndMe
import Foundation
import KeychainSwift

// MARK: Test Codable Macros
@Codable
struct Foo: Codable, Identifiable {
    let id = UUID()
    var bar: Int
    let baz: String
}

@CodableIgnoreInitializedProperties
struct Bar: Identifiable {
    let id = UUID()
    var bar: Int
    let baz: String
}

// MARK: SecureStorage Macro

@SecureStorage("test") var secureTest: String?


// MARK: Test AddSynchronous Macro

@AddSynchronous
func asyncFunction(test: String) async throws -> String {
    try await Task.sleep(nanoseconds: 3_000_000_000)
    return test
}

// Avoid quitting before async finishes
let semaphore = DispatchSemaphore(value: 0)

asyncFunction(test: "Hello World!") { value, error in
    if let value {
        print("Value: \(value)")
    }
    if let error {
        print("Error: \(error)")
    }
    semaphore.signal()
}

semaphore.wait()

// MARK: URL Macro
let compileTimeSafeURL = #URL("https://mcrich23.com")

// MARK: Base64 Encoded Macro
let secretMessage = #base64Encoded("Hello World!")!
print(secretMessage)
