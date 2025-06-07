import SwiftMacrosAndMe
import Foundation

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@CodableIgnoreInitializedProperties_Member
struct Foo: Codable, Identifiable {
    @CodableIgnored var id = UUID()
    var bar: Int
    let baz: String
}
