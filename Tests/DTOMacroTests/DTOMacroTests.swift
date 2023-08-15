import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import DTOMacrosImpl

let testMacros: [String: Macro.Type] = [
    "DecodableFromDTO": DecodableFromDTOMacro.self,
]

final class DTOMacroTests: XCTestCase {
    func testMacro() {
        
    }

    func testMacroWithStringLiteral() {
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
    }
}
