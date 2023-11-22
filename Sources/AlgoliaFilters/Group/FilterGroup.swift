import AlgoliaFoundation
import Foundation
import Combine

public protocol FilterGroup: CustomStringConvertible {
  /// List of filters in the group
  var filters: [any Filter] { get }
  var filtersPublisher: Published<[any Filter]>.Publisher { get }

  var rawValue: String { get }
  var rawValuePublisher: Published<String>.Publisher { get }

  /// Whether the group is empty
  var isEmpty: Bool { get }

  /// Return filters with the specified attribute
  func filters(withAttribute attribute: Attribute) -> [any Filter]

  /// Remove all filters with the specified attribute from the group
  func removeFilters(withAttribute attribute: Attribute)

/// Remove all filters from the group
  func removeAll()
}
