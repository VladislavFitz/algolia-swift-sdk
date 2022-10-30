import Foundation
/**
 Precision of geo search (in meters), to add grouping by geo location to the ranking formula.
 - Engine default: 1
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundPrecision/?language=swift)
 */
struct AroundPrecision {
  static let key = "aroundPrecision"
  public var key: String { Self.key }
  let value: Either<Int, [AroundPrecisionFromDistance]>

  init(_ value: Either<Int, [AroundPrecisionFromDistance]>) {
    self.value = value
  }

  init(_ intValue: Int) {
    self.init(.first(intValue))
  }

  init(_ precisions: AroundPrecisionFromDistance...) {
    self.init(.second(precisions))
  }

  init(_ precisions: [AroundPrecisionFromDistance]) {
    self.init(.second(precisions))
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension AroundPrecision: SearchParameter {
  var urlEncodedString: String {
    switch value {
    case let .first(intValue):
      return "\(intValue)"
    case let .second(listValue):
      return "\(listValue.map(\.urlEncodedString))"
    }
  }
}

extension SearchParameters {
  /**
   Precision of geo search (in meters), to add grouping by geo location to the ranking formula.
   - Engine default: 1
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundPrecision/?language=swift)
   */
  var aroundPrecision: Either<Int, [AroundPrecisionFromDistance]>? {
    get {
      (parameters[AroundPrecision.key] as? AroundPrecision)?.value
    }
    set {
      parameters[AroundPrecision.key] = newValue.flatMap(AroundPrecision.init)
    }
  }
}

extension AroundPrecision: DeleteQueryParameter {}

extension DeleteQueryParameters {
  /**
   Precision of geo search (in meters), to add grouping by geo location to the ranking formula.
   - Engine default: 1
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundPrecision/?language=swift)
   */
  var aroundPrecision: Either<Int, [AroundPrecisionFromDistance]>? {
    get {
      (parameters[AroundPrecision.key] as? AroundPrecision)?.value
    }
    set {
      parameters[AroundPrecision.key] = newValue.flatMap(AroundPrecision.init)
    }
  }
}
