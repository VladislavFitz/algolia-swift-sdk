import Foundation
/**
 Search inside a polygon (in geo coordinates).
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insidePolygon/?language=swift)
 */
struct InsidePolygon {
  static let key = "insidePolygon"
  public var key: String { Self.key }
  let value: Polygon

  init(_ value: Polygon) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension InsidePolygon: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Search inside a polygon (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insidePolygon/?language=swift)
   */
  var insidePolygon: Polygon? {
    get {
      (parameters[InsidePolygon.key] as? InsidePolygon)?.value
    }
    set {
      parameters[InsidePolygon.key] = newValue.flatMap(InsidePolygon.init)
    }
  }
}

extension InsidePolygon: DeleteQueryParameter {}

extension DeleteQueryParameters {
  /**
   Search inside a polygon (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insidePolygon/?language=swift)
   */
  var insidePolygon: Polygon? {
    get {
      (parameters[InsidePolygon.key] as? InsidePolygon)?.value
    }
    set {
      parameters[InsidePolygon.key] = newValue.flatMap(InsidePolygon.init)
    }
  }
}
