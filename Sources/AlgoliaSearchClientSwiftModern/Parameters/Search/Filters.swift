import Foundation
/**
 Filter the query with numeric, facet and/or tag filters.
 - Engine default: ""
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/filters/?language=swift)
 */
public struct Filters {
  static let key = "filters"
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

extension Filters: SearchParameter {
  public var urlEncodedString: String {
    return value
  }
}

extension SearchParameters {
  /**
   Filter the query with numeric, facet and/or tag filters.
   - Engine default: ""
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/filters/?language=swift)
   */
  var filters: String? {
    get {
      (parameters[Filters.key] as? Filters)?.value
    }
    set {
      parameters[Filters.key] = newValue.flatMap(Filters.init)
    }
  }
}

extension Filters: DeleteQueryParameter {}

extension DeleteQueryParameters {
  /**
   Filter the query with numeric, facet and/or tag filters.
   - Engine default: ""
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/filters/?language=swift)
   */
  var filters: String? {
    get {
      (parameters[Filters.key] as? Filters)?.value
    }
    set {
      parameters[Filters.key] = newValue.flatMap(Filters.init)
    }
  }
}
