import Foundation
/**
 Filter hits by facet value.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facetFilters/?language=swift)
 */
struct FacetFilters {
  static let key = "facetFilters"
  public var key: String { Self.key }
  let value: FiltersStorage

  init(_ value: FiltersStorage) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension FacetFilters: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
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

extension DeleteQueryParameters {
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
