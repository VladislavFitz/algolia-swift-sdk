import AlgoliaFoundation
import Foundation
/**
 Define the maximum radius for a geo search (in meters).
 - This setting only works within the context of a radial (circular) geo search,
   enabled by aroundLatLngViaIP or aroundLatLng.
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundRadius/?language=swift)
 */
public struct AroundRadius: ValueRepresentable, Hashable {
  static let key = "aroundRadius"
  public let key: String
  public let value: Value

  public init(_ value: Value) {
    key = AroundRadius.key
    self.value = value
  }
}

public extension AroundRadius {
  enum Value: Codable, Hashable, URLEncodable {
    /**
      Disables the radius logic, allowing all results to be returned, regardless of distance.
      Ranking is still based on proximity to the central axis point.
      This option is faster than specifying a high integer value.
     */
    case all

    /**
     Integer value (in meters) representing the radius around the coordinates specified during the query.
     */
    case meters(Int)

    /**
     Custom string value
     */
    case custom(String)
  }
}

extension AroundRadius.Value: RawRepresentable {
  public var rawValue: Either<String, Int> {
    switch self {
    case .all:
      return .first("all")
    case let .meters(meters):
      return .second(meters)
    case let .custom(rawValue):
      return .first(rawValue)
    }
  }

  public var urlEncodedString: String {
    switch self {
    case let .meters(meters):
      return "\(meters)"
    case .all:
      return "all"
    case let .custom(value):
      return value
    }
  }

  public init(rawValue: Either<String, Int>) {
    switch rawValue {
    case let .first(stringValue):
      switch stringValue {
      case "all":
        self = .all
      case _ where Int(stringValue) != nil:
        self = .meters(Int(stringValue)!)
      default:
        self = .custom(stringValue)
      }
    case let .second(intValue):
      self = .meters(intValue)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .all:
      try container.encode("all")
    case let .meters(meters):
      try container.encode(meters)
    case let .custom(value):
      try container.encode(value)
    }
  }
}

extension AroundRadius: SearchParameter {}

public extension SearchParameters {
  /**
   Define the maximum radius for a geo search (in meters).
   - This setting only works within the context of a radial (circular) geo search,
     enabled by aroundLatLngViaIP or aroundLatLng.
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundRadius/?language=swift)
   */
  var aroundRadius: AroundRadius.Value? {
    get {
      (parameters[AroundRadius.key] as? AroundRadius)?.value
    }
    set {
      parameters[AroundRadius.key] = newValue.flatMap(AroundRadius.init)
    }
  }
}

extension AroundRadius: DeleteQueryParameter {}

public extension DeleteQueryParameters {
  /**
   Define the maximum radius for a geo search (in meters).
   - This setting only works within the context of a radial (circular) geo search,
     enabled by aroundLatLngViaIP or aroundLatLng.
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundRadius/?language=swift)
   */
  var aroundRadius: AroundRadius.Value? {
    get {
      (parameters[AroundRadius.key] as? AroundRadius)?.value
    }
    set {
      parameters[AroundRadius.key] = newValue.flatMap(AroundRadius.init)
    }
  }
}
