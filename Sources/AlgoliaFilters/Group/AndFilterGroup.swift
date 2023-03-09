import AlgoliaFoundation
import Foundation

/// Conjunctive filter group сombines filters with the logical operator "and".
/// Can contain filters of different types at the same time.
public final class AndFilterGroup: FilterGroup {
  @Published public private(set) var filters: [any Filter]

  public let separator: String = " AND "

  public var isEmpty: Bool {
    return filters.isEmpty
  }

  public init(filters: [any Filter] = []) {
    self.filters = filters
  }

  public func filters(withAttribute attribute: Attribute) -> [any Filter] {
    filters.filter { $0.attribute == attribute }
  }

  public func add(_ filter: any Filter) {
    filters.append(filter)
  }

  /// Remove filter from the group
  public func remove<F: Filter>(_ filter: F) {
    filters.removeAll {
      ($0 as? F) == filter
    }
  }

  public func removeFilters(withAttribute attribute: Attribute) {
    filters.removeAll { $0.attribute == attribute }
  }

  public func removeAll() {
    filters.removeAll()
  }
}

public extension AndFilterGroup {
  /// Textual representation of the group accepted by Algolia API
  var description: String {
    return "( \(filters.map { $0.description }.sorted().joined(separator: " AND ")) )"
  }
}
