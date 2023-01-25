import AlgoliaFoundation
import Foundation
/**
 Filter hits by tags.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/tagFilters/?language=swift)
 */
public struct TagFilters: ValueRepresentable {
  static let key = "tagFilters"
  public var key: String { Self.key }
  public let value: FiltersStorage

  public init(_ value: FiltersStorage) {
    self.value = value
  }
}

extension TagFilters: SearchParameter {}

public extension SearchParameters {
  /**
   Filter hits by tags.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/tagFilters/?language=swift)
   */
  var tagFilters: FiltersStorage? {
    get {
      (parameters[TagFilters.key] as? TagFilters)?.value
    }
    set {
      parameters[TagFilters.key] = newValue.flatMap(TagFilters.init)
    }
  }
}

extension TagFilters: DeleteQueryParameter {}

public extension DeleteQueryParameters {
  /**
   Filter hits by tags.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/tagFilters/?language=swift)
   */
  var tagFilters: FiltersStorage? {
    get {
      (parameters[TagFilters.key] as? TagFilters)?.value
    }
    set {
      parameters[TagFilters.key] = newValue.flatMap(TagFilters.init)
    }
  }
}
