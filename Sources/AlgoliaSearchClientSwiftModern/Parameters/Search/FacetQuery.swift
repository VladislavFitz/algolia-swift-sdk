import Foundation

struct FacetQuery {
  let key = "facetQuery"
  let value: String

  init(_ value: String) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension FacetQuery: SearchParameter {
  var urlEncodedString: String {
    return value
  }
}

extension SearchParameters {
  var facetQuery: String? {
    get {
      (parameters[Query.key] as? Query)?.value
    }
    set {
      parameters[Query.key] = newValue.flatMap(Query.init)
    }
  }
}
