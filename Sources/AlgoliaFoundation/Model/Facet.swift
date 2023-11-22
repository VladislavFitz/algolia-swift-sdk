import Foundation

/// A value of a given facet, together with its number of occurrences.
/// This struct is mainly useful when an ordered list of facet values has to be presented to the user.
///
public struct Facet: Codable, Equatable, Hashable {
  public let value: String
  public let count: Int
  public let highlighted: String?

  public init(value: String, count: Int, highlighted: String? = nil) {
    self.value = value
    self.count = count
    self.highlighted = highlighted
  }
}

public extension Facet {
  var isEmpty: Bool {
    return count < 1
  }
}

extension Facet: CustomStringConvertible {
  public var description: String {
    return "\(value) (\(count))"
  }
}

public extension [Facet] {
  init(facetDictionary: [String: Int]) {
    self = facetDictionary.map { value, count in
      Facet(value: value, count: count)
    }
  }
}

public extension [Attribute: [Facet]] {
  init(rawFacets: [String: [String: Int]]) {
    let int = rawFacets.map { key, value in
      (Attribute(rawValue: key), [Facet](facetDictionary: value))
    }
    self = [Attribute: [Facet]](uniqueKeysWithValues: int)
  }
}
