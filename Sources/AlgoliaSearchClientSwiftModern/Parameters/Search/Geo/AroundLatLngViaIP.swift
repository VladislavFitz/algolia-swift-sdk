import Foundation
/**
 Whether to search entries around a given location automatically computed from the requester’s IP address.
 - Engine default: false
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundLatLngViaIP/?language=swift)
 */
struct AroundLatLngViaIP {
  static let key = "aroundLatLngViaIP"
  public var key: String { Self.key }
  let value: Bool

  init(_ value: Bool) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension AroundLatLngViaIP: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
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
