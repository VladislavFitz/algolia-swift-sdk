import Foundation
import AlgoliaFoundation

/// Disjunctive filter group сombines filters with the logical operator "or".
/// Can contain filters of the same type only (facet, numeric or tag).
final public class OrFilterGroup<GroupFilter: Filter>: FilterGroup {
  
  @Published private(set) public var filters: [GroupFilter]
  
  public var separator: String = " OR "
  
  public var isEmpty: Bool {
    return filters.isEmpty
  }
  
  public init(filters: [GroupFilter] = []) {
    self.filters = filters
  }
  
  public func filters(withAttribute attribute: Attribute) -> [GroupFilter] {
    filters.filter { $0.attribute == attribute }
  }
  
  public func add(_ filter: GroupFilter) {
    filters.append(filter)
  }
  
  /// Remove filter from the group
  public func remove(_ filter: GroupFilter) {
    filters.removeAll {
      $0 == filter
    }
  }
  
  public func removeFilters(withAttribute attribute: Attribute) {
    filters.removeAll { $0.attribute == attribute }
  }
  
  public func removeAll() {
    filters.removeAll()
  }
  
}

extension OrFilterGroup: CustomStringConvertible {
  
  /// Textual representation of the group accepted by Algolia API
  public var description: String {
    return "( \(filters.map { $0.description }.joined(separator: " OR ")) )"
  }
  
}
