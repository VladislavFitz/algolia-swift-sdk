import Foundation
/**
 The search query used to search the facet attribute.
 - Facet queries only match prefixes, typos, and exact.
 */
public struct FacetQuery {
  public static let key = "facetQuery"
  public var key: String { Self.key }
  public let value: String

  public init(_ value: String) {
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension FacetQuery: SearchParameter {
  public var urlEncodedString: String {
    return value
  }
}

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
