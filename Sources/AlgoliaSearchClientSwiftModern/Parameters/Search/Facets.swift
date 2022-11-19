import Foundation
/**
 Facets to retrieve.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facets/?language=swift)
 */
struct Facets {
  static let key = "facets"
  var key: String { Self.key }
  let value: [Attribute]

  init(_ value: [Attribute]) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension Facets: SearchParameter {
  var urlEncodedString: String {
    return "[\(value.map(\.rawValue).joined(separator: ","))]"
  }
}

extension SearchParameters {
  /**
   Facets to retrieve.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facets/?language=swift)
   */
  var facets: [Attribute]? {
    get {
      (parameters[Facets.key] as? Facets)?.value
    }
    set {
      parameters[Facets.key] = newValue.flatMap(Facets.init)
    }
  }
}
