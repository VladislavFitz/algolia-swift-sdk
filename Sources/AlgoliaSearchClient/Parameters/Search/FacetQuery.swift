import AlgoliaFoundation
import Foundation
/**
 The search query used to search the facet attribute.
 - Facet queries only match prefixes, typos, and exact.
 */
public struct FacetQuery: ValueRepresentable {
  public static let key = "facetQuery"
  public var key: String { Self.key }
  public let value: String

  public init(_ value: String) {
    self.value = value
  }
}

extension FacetQuery: SearchParameter {}

public extension SearchParameters {
  /**
   The search query used to search the facet attribute.
   - Facet queries only match prefixes, typos, and exact.
   */
  var facetQuery: String? {
    get {
      (parameters[FacetQuery.key] as? FacetQuery)?.value
    }
    set {
      parameters[FacetQuery.key] = newValue.flatMap(FacetQuery.init)
    }
  }
}
