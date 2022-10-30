import Foundation
/**
 Create filters for ranking purposes, where records that match the filter are ranked highest.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/optionalFilters/?language=swift)
 */
struct OptionalFilters {
  static let key = "optionalFilters"
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

extension OptionalFilters: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Create filters for ranking purposes, where records that match the filter are ranked highest.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/optionalFilters/?language=swift)
   */
  var optionalFilters: FiltersStorage? {
    get {
      (parameters[OptionalFilters.key] as? OptionalFilters)?.value
    }
    set {
      parameters[OptionalFilters.key] = newValue.flatMap(OptionalFilters.init)
    }
  }
}

extension OptionalFilters: DeleteQueryParameter {}

extension DeleteQueryParameters {
  /**
   Create filters for ranking purposes, where records that match the filter are ranked highest.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/optionalFilters/?language=swift)
   */
  var optionalFilters: FiltersStorage? {
    get {
      (parameters[OptionalFilters.key] as? OptionalFilters)?.value
    }
    set {
      parameters[OptionalFilters.key] = newValue.flatMap(OptionalFilters.init)
    }
  }
}
