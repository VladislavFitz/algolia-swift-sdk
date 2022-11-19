import Foundation
/**
 Whether this query should be taken into consideration by currently active ABTests.
 - Engine default: true
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/enableABTest/?language=swift)
 */
struct EnableABTest {
  static let key = "enableABTest"
  public var key: String { Self.key }
  let value: Bool
  
  init(_ value: Bool) {
    self.value = value
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension EnableABTest: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
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
