import AlgoliaFoundation
import Foundation
/**
 Precision of geo search (in meters), to add grouping by geo location to the ranking formula.
 - Engine default: 1
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/aroundPrecision/?language=swift)
 */
public struct AroundPrecision: ValueRepresentable {
  static let key = "aroundPrecision"
  public var key: String { Self.key }
  public let value: Either<Int, [AroundPrecisionFromDistance]>

  public init(_ value: Either<Int, [AroundPrecisionFromDistance]>) {
    self.value = value
  }

  public init(_ intValue: Int) {
    self.init(.first(intValue))
  }

  public init(_ precisions: AroundPrecisionFromDistance...) {
    self.init(.second(precisions))
  }

  public init(_ precisions: [AroundPrecisionFromDistance]) {
    self.init(.second(precisions))
  }
}

extension AroundPrecision: SearchParameter {}

public extension SearchParameters {
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

public extension DeleteQueryParameters {
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
