import Foundation
/**
 Specify the page to retrieve.
 - Engine default: 0
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/page/?language=swift)
 */
public struct Page: ValueRepresentable {
  static let key = "page"
  public var key: String { Self.key }
  public let value: Int

  public init(_ value: Int) {
    self.value = value
  }
}

extension Page: SearchParameter {}

public extension SearchParameters {
  /**
   Specify the page to retrieve.
   - Engine default: 0
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/page/?language=swift)
   */
  var page: Int? {
    get {
      (parameters[Page.key] as? Page)?.value
    }
    set {
      parameters[Page.key] = newValue.flatMap(Page.init)
    }
  }
}
