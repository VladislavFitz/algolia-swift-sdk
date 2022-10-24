import Foundation
/**
 Minimum radius (in meters) used for a geo search when [aroundRadius] is not set.
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/minimumAroundRadius/?language=swift)
 */
public struct MinimumAroundRadius {
  static let key = "minimumAroundRadius"
  public let key: String = MinimumAroundRadius.key
  public let value: Int

  public init(_ value: Int) {
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension MinimumAroundRadius: SearchParameter {
  public var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  /**
   Minimum radius (in meters) used for a geo search when [aroundRadius] is not set.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/minimumAroundRadius/?language=swift)
   */
  var minimumAroundRadius: Int? {
    get {
      (parameters[MinimumAroundRadius.key] as? MinimumAroundRadius)?.value
    }
    set {
      parameters[MinimumAroundRadius.key] = newValue.flatMap(MinimumAroundRadius.init)
    }
  }
}
