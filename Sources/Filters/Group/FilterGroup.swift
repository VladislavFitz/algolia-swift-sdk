import Foundation
import AlgoliaFoundation

public protocol FilterGroup: CustomStringConvertible {

  associatedtype Filter

  /// List of filters in the group
  var filters: [Filter] { get }

  /// A string that splits the text representation of the filters in the string representation.
  var separator: String { get }

  /// Whether the group is empty
  var isEmpty: Bool { get }

  /// Return filters with the specified attribute
  func filters(withAttribute attribute: Attribute) -> [Filter]

  /// Add filter to the group
  func add(_ filter: Filter)

  /// Remove all filters with the specified attribute from the group
  func removeFilters(withAttribute attribute: Attribute)

  /// Remove all filters from the group
  func removeAll()

}
