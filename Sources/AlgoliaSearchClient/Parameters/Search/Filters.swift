import AlgoliaFoundation
import Foundation
/**
 Filter the query with numeric, facet and/or tag filters.
 - Engine default: ""
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/filters/?language=swift)
 */
public struct Filters: ValueRepresentable {
  static let key = "filters"
  public var key: String { Self.key }
  public let value: String

  public init(_ value: String) {
    self.value = value
  }
}

extension Filters: SearchParameter {}

public extension SearchParameters {
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

public extension DeleteQueryParameters {
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
