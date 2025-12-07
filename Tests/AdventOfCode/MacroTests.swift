import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest


// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(UtilsMacros)
import UtilsMacros

private let testMacros: [String: Macro.Type] = [
    "Memoize": MemoizeMacro.self
]
#endif

final class MacroTests: XCTestCase {
    func testRecursizeMemoize() throws {
#if canImport(UtilsMacros)
        assertMacroExpansion(
"""
class SomeObject {
 @Memoize
 func someFunc(with a: Int, b: Double) -> Int {
  return a * Int(b)
 }
}
""",
expandedSource:
"""
class SomeObject {
 func someFunc(with a: Int, b: Double) -> Int {
  func internalFunction(with a: Int, b: Double) -> Int {
  return a * Int(b)
  }
  let key = _makeSomeFuncHash(with: a, b: b)
  if let cached = _someFuncStorage[key] {
  return cached
  }

  let result = internalFunction(with: a, b: b)
  _someFuncStorage[key] = result
  return result
 }

 private var _someFuncStorage = [Int: Int]()

 private func _makeSomeFuncHash(with a: Int, b: Double) -> Int {
  var hasher = Hasher()
  hasher.combine(a)
  hasher.combine(b)
  return hasher.finalize()
 }
}
""",
macros: testMacros,
indentationWidth: .spaces(1))
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
