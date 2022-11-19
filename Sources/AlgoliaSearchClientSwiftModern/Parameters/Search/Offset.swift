import Foundation
/**
 Specify the offset of the first hit to return.
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/offset/?language=swift)
 */
struct Offset {
  static let key = "offset"
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

extension Offset: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Specify the offset of the first hit to return.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/offset/?language=swift)
   */
  var offset: Int? {
    get {
      (parameters[Offset.key] as? Offset)?.value
    }
    set {
      parameters[Offset.key] = newValue.flatMap(Offset.init)
    }
  }
}
