import Foundation
/**
 Enable the Click Analytics feature.
 - Engine default: false.
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/clickAnalytics/?language=swift)
 */
struct ClickAnalytics {
  static let key = "clickAnalytics"
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

extension ClickAnalytics: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Enable the Click Analytics feature.
   - Engine default: false.
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/clickAnalytics/?language=swift)
   */
  var clickAnalytics: Bool? {
    get {
      (parameters[ClickAnalytics.key] as? ClickAnalytics)?.value
    }
    set {
      parameters[ClickAnalytics.key] = newValue.flatMap(ClickAnalytics.init)
    }
  }
}
