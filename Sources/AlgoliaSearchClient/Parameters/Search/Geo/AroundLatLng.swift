import AlgoliaFoundation
import Foundation
/**
 Search for entries around a central geolocation, enabling a geo search within a circular area.
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLng/?language=swift)
 */
public struct AroundLatLng: ValueRepresentable {
  public static let key = "aroundLatLng"
  public var key: String { Self.key }
  public let value: Point

  public init(_ value: Point) {
    self.value = value
  }

  public init(latitude: Double, longitude: Double) {
    self.init(Point(latitude: latitude, longitude: longitude))
  }
}

extension AroundLatLng: SearchParameter, Hashable {}

public extension SearchParameters {
  /**
   Search for entries around a central geolocation, enabling a geo search within a circular area.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLng/?language=swift)
   */
  var aroundLatLng: Point? {
    get {
      (parameters[AroundLatLng.key] as? AroundLatLng)?.value
    }
    set {
      parameters[AroundLatLng.key] = newValue.flatMap(AroundLatLng.init)
    }
  }
}

extension AroundLatLng: DeleteQueryParameter {}

public extension DeleteQueryParameters {
  /**
   Search for entries around a central geolocation, enabling a geo search within a circular area.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLng/?language=swift)
   */
  var aroundLatLng: Point? {
    get {
      (parameters[AroundLatLng.key] as? AroundLatLng)?.value
    }
    set {
      parameters[AroundLatLng.key] = newValue.flatMap(AroundLatLng.init)
    }
  }
}
