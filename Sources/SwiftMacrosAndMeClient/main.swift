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

let fooConformsToCodable = (Foo(bar: 1, baz: "2") as? Codable) == nil ? false : true
print(fooConformsToCodable)

@SecureStorage("test") var secureTest: String?
