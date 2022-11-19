import Foundation
/**
 The text to search in the index.
 - Engine default: ""
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/query/?language=swift)
 */
public struct Query: ValueRepresentable {
  static let key = "query"
  public var key: String { Self.key }
  public let value: String

  public init(_ value: String) {
    self.value = value
  }
}

extension Query: SearchParameter {}

public extension SearchParameters {
  /**
    The text to search in the index.
    - Engine default: ""
    - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/query/?language=swift)
   */
  var query: String? {
    get {
      (parameters[Query.key] as? Query)?.value
    }
    set {
      parameters[Query.key] = newValue.flatMap(Query.init)
    }
  }
}
