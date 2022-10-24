import Foundation
/**
 Whether the current query will be taken into account in the Analytics.
 - Engine default: true
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/analytics/?language=swift)
 */
struct Analytics {
  static let key = "analytics"
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

extension Analytics: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Whether the current query will be taken into account in the Analytics.
   - Engine default: true
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/analytics/?language=swift)
   */
  var analytics: Bool? {
    get {
      (parameters[Analytics.key] as? Analytics)?.value
    }
    set {
      parameters[Analytics.key] = newValue.flatMap(Analytics.init)
    }
  }
}
