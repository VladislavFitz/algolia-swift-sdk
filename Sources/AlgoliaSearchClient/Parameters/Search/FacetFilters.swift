import AlgoliaFoundation
import Foundation
/**
 Filter hits by facet value.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facetFilters/?language=swift)
 */
public struct FacetFilters: ValueRepresentable {
  static let key = "facetFilters"
  public var key: String { Self.key }
  public let value: FiltersStorage

  public init(_ value: FiltersStorage) {
    self.value = value
  }
}

extension FacetFilters: SearchParameter {}

public extension SearchParameters {
  /**
   Filter hits by facet value.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facetFilters/?language=swift)
   */
  var facetFilters: FiltersStorage? {
    get {
      (parameters[FacetFilters.key] as? FacetFilters)?.value
    }
    set {
      parameters[FacetFilters.key] = newValue.flatMap(FacetFilters.init)
    }
  }
}

extension FacetFilters: DeleteQueryParameter {}

public extension DeleteQueryParameters {
  /**
   Filter hits by facet value.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facetFilters/?language=swift)
   */
  var facetFilters: FiltersStorage? {
    get {
      (parameters[FacetFilters.key] as? FacetFilters)?.value
    }
    set {
      parameters[FacetFilters.key] = newValue.flatMap(FacetFilters.init)
    }
  }
}
