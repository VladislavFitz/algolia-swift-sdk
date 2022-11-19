import Foundation
/**
 Whether the current query will be taken into account in the Analytics.
 - Engine default: true
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/analytics/?language=swift)
 */
public struct Analytics: ValueRepresentable {
  static let key = "analytics"
  public var key: String { Self.key }
  public let value: Bool

  public init(_ value: Bool) {
    self.value = value
  }
}

extension Analytics: SearchParameter {}

public extension SearchParameters {
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
