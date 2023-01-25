import Foundation

public extension String {
  func wrappedInQuotes() -> String { "\"\(self)\"" }
  func wrappedInBrackets() -> String { "[\(self)]" }
}
