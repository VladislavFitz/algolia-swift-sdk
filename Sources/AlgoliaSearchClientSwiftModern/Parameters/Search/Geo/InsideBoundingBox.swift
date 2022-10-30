import Foundation
/**
 Search inside a rectangular area (in geo coordinates).
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insideBoundingBox/?language=swift)
 */
struct InsideBoundingBox {
  static let key = "insideBoundingBox"
  public var key: String { Self.key }
  let value: [BoundingBox]

  init(_ value: [BoundingBox]) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension InsideBoundingBox: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Search inside a rectangular area (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insideBoundingBox/?language=swift)
   */
  var insideBoundingBox: [BoundingBox]? {
    get {
      (parameters[InsideBoundingBox.key] as? InsideBoundingBox)?.value
    }
    set {
      parameters[InsideBoundingBox.key] = newValue.flatMap(InsideBoundingBox.init)
    }
  }
}

extension InsideBoundingBox: DeleteQueryParameter {}

extension DeleteQueryParameters {
  /**
   Search inside a rectangular area (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insideBoundingBox/?language=swift)
   */
  var insideBoundingBox: [BoundingBox]? {
    get {
      (parameters[InsideBoundingBox.key] as? InsideBoundingBox)?.value
    }
    set {
      parameters[InsideBoundingBox.key] = newValue.flatMap(InsideBoundingBox.init)
    }
  }
}
