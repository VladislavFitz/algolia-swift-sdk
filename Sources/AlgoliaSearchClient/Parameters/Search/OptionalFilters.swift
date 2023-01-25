import AlgoliaFoundation
import Foundation
/**
 Create filters for ranking purposes, where records that match the filter are ranked highest.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/optionalFilters/?language=swift)
 */
public struct OptionalFilters: ValueRepresentable {
  static let key = "optionalFilters"
  public var key: String { Self.key }
  public let value: FiltersStorage

  public init(_ value: FiltersStorage) {
    self.value = value
  }
}

extension OptionalFilters: SearchParameter {}

public extension SearchParameters {
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

public extension DeleteQueryParameters {
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
