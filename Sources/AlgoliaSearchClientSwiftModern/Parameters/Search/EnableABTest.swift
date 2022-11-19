import Foundation
/**
 Whether this query should be taken into consideration by currently active ABTests.
 - Engine default: true
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/enableABTest/?language=swift)
 */
public struct EnableABTest: ValueRepresentable {
  static let key = "enableABTest"
  public var key: String { Self.key }
  public let value: Bool

  public init(_ value: Bool) {
    self.value = value
  }
}

extension EnableABTest: SearchParameter {}

public extension SearchParameters {
  /**
   Whether this query should be taken into consideration by currently active ABTests.
   - Engine default: true
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/enableABTest/?language=swift)
   */
  var enableABTest: Bool? {
    get {
      (parameters[EnableABTest.key] as? EnableABTest)?.value
    }
    set {
      parameters[EnableABTest.key] = newValue.flatMap(EnableABTest.init)
    }
  }
}
