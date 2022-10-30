import Foundation
/**
 Filter on numeric attributes.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/numericFilters/?language=swift)
 */
struct NumericFilters {
  static let key = "numericFilters"
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

extension NumericFilters: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
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

extension DeleteQueryParameters {
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
