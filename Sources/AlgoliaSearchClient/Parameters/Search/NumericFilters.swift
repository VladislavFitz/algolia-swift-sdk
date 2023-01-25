import AlgoliaFoundation
import Foundation
/**
 Filter on numeric attributes.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/numericFilters/?language=swift)
 */
public struct NumericFilters: ValueRepresentable {
  static let key = "numericFilters"
  public var key: String { Self.key }
  public let value: FiltersStorage

  public init(_ value: FiltersStorage) {
    self.value = value
  }
}

extension NumericFilters: SearchParameter {}

public extension SearchParameters {
  /**
   Filter on numeric attributes.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/numericFilters/?language=swift)
   */
  var numericFilters: FiltersStorage? {
    get {
      (parameters[NumericFilters.key] as? NumericFilters)?.value
    }
    set {
      parameters[NumericFilters.key] = newValue.flatMap(NumericFilters.init)
    }
  }
}

extension NumericFilters: DeleteQueryParameter {}

public extension DeleteQueryParameters {
  /**
   Filter on numeric attributes.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/numericFilters/?language=swift)
   */
  var numericFilters: FiltersStorage? {
    get {
      (parameters[NumericFilters.key] as? NumericFilters)?.value
    }
    set {
      parameters[NumericFilters.key] = newValue.flatMap(NumericFilters.init)
    }
  }
}
