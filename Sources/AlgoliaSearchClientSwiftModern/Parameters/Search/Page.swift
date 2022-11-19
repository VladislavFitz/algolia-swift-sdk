import Foundation
/**
 Specify the page to retrieve.
 - Engine default: 0
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/page/?language=swift)
 */
struct Page {
  static let key = "page"
  public var key: String { Self.key }
  let value: Int
  
  init(_ value: Int) {
    self.value = value
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension Page: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Specify the page to retrieve.
   - Engine default: 0
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/page/?language=swift)
   */
  var page: Int? {
    get {
      (parameters[Page.key] as? Page)?.value
    }
    set {
      parameters[Page.key] = newValue.flatMap(Page.init)
    }
  }
}
