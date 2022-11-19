import Foundation
/**
 Whether to search entries around a given location automatically computed from the requester’s IP address.
 - Engine default: false
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLngViaIP/?language=swift)
 */
public struct AroundLatLngViaIP: ValueRepresentable {
  static let key = "aroundLatLngViaIP"
  public var key: String { Self.key }
  public let value: Bool

  public init(_ value: Bool) {
    self.value = value
  }
}

extension AroundLatLngViaIP: SearchParameter {}

public extension SearchParameters {
  /**
   Whether to search entries around a given location automatically computed from the requester’s IP address.
   - Engine default: false
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLngViaIP/?language=swift)
   */
  var aroundLatLngViaIP: Bool? {
    get {
      (parameters[AroundLatLngViaIP.key] as? AroundLatLngViaIP)?.value
    }
    set {
      parameters[AroundLatLngViaIP.key] = newValue.flatMap(AroundLatLngViaIP.init)
    }
  }
}
