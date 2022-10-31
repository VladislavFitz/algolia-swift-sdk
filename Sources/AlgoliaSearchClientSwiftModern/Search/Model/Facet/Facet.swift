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
