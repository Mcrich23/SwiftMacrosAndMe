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
func asyncFunction(test: String) async {
    print("Hello, World!")
}
