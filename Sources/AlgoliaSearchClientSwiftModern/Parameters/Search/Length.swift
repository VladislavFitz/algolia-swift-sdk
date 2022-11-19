import Foundation
/**
 Set the number of hits to retrieve (used only with offset).
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/length/?language=swift)
 */
struct Length {
  static let key = "length"
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

extension Length: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Set the number of hits to retrieve (used only with offset).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/length/?language=swift)
   */
  var length: Int? {
    get {
      (parameters[Length.key] as? Length)?.value
    }
    set {
      parameters[Length.key] = newValue.flatMap(Length.init)
    }
  }
}
