import Foundation
/**
 Facets to retrieve.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/facets/?language=swift)
 */
public struct Facets: ValueRepresentable {
  static let key = "facets"
  public var key: String { Self.key }
  public let value: [Attribute]

  public init(_ value: [Attribute]) {
    self.value = value
  }
}

extension Facets: SearchParameter {}

public extension SearchParameters {
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
