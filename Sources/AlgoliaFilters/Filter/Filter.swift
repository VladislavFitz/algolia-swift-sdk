import AlgoliaFoundation

/// Abstract filter protocol
public protocol Filter: Equatable, CustomStringConvertible {
  /// Identifier of field affected by filter
  var attribute: Attribute { get }

  /// A Boolean value indicating whether filter is inverted
  var isNegated: Bool { get set }

  /// Replaces isNegated property by a new value
  /// parameter value: new value of isNegated
  mutating func not(value: Bool)
}

public extension Filter {
  mutating func not(value: Bool = true) {
    isNegated = value
  }
}

@discardableResult public prefix func ! <T: Filter>(filter: T) -> T {
  var mutableFilterCopy = filter
  mutableFilterCopy.not(value: !filter.isNegated)
  return mutableFilterCopy
}
