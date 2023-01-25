import AlgoliaFoundation
import Foundation
/**
 Search inside a polygon (in geo coordinates).
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insidePolygon/?language=swift)
 */
public struct InsidePolygon: ValueRepresentable {
  static let key = "insidePolygon"
  public var key: String { Self.key }
  public let value: Polygon

  public init(_ value: Polygon) {
    self.value = value
  }
}

extension InsidePolygon: SearchParameter {}

public extension SearchParameters {
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

public extension DeleteQueryParameters {
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
