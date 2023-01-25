import AlgoliaFoundation
import Foundation
/**
 Enable the Click Analytics feature.
 - Engine default: false.
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/clickAnalytics/?language=swift)
 */
public struct ClickAnalytics: ValueRepresentable {
  static let key = "clickAnalytics"
  public var key: String { Self.key }
  public let value: Bool

  public init(_ value: Bool) {
    self.value = value
  }
}

extension ClickAnalytics: SearchParameter {}

public extension SearchParameters {
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
