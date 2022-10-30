import Foundation
/**
 Filter hits by tags.
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/tagFilters/?language=swift)
 */
struct TagFilters {
  static let key = "tagFilters"
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

extension TagFilters: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
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

extension DeleteQueryParameters {
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
