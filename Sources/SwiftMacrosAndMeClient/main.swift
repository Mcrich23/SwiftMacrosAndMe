import SwiftMacrosAndMe
import Foundation
import KeychainSwift

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@CodableIgnoreInitializedProperties
struct Foo: Identifiable {
    let id = UUID()
    var bar: Int
    let baz: String
}

@Codable
struct Bar: Identifiable {
    @CodableIgnored let id = UUID()
    var bar: Int
    let baz: String
}

@SecureStorage("test") var secureTest: String?

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
