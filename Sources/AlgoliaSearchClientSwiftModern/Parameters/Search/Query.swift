import Foundation
/**
 The text to search in the index.
 - Engine default: ""
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/query/?language=swift)
 */
public struct Query {
  static let key = "query"
  public var key: String { Self.key }
  public let value: String

  init(_ value: String) {
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension Query: SearchParameter {
  public var urlEncodedString: String {
    return value
  }
}

extension SearchParameters {
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
