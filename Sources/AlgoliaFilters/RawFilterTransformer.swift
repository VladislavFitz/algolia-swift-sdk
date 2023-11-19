import Foundation

public enum FilterSeparator: String {
  case and = " AND "
  case or = " OR "
}

public struct RawFilterTransformer {
  
  private static let negationPrefix = "NOT "
  
  public static func transform(_ filter: FacetFilter) -> String {
    let scoreExpression = filter.score.flatMap { "<score=\(String($0))>" } ?? ""
    let expression = """
    "\(filter.attribute)":"\(filter.value)\(scoreExpression)"
    """
    let prefix = filter.isNegated ? negationPrefix : ""
    return prefix + expression
  }
  
  public static func transform(_ filter: NumericFilter) -> String {
    let expression: String
    switch filter.value {
    case let .comparison(`operator`, value):
      expression = """
      "\(filter.attribute)" \(`operator`.rawValue) \(value)
      """

    case let .range(range):
      expression = """
      "\(filter.attribute)":\(range.lowerBound) TO \(range.upperBound)
      """
    }
    let prefix = filter.isNegated ? negationPrefix : ""
    return prefix + expression
  }
  
  public static func transform(_ filter: TagFilter) -> String {
    let expression = """
    "\(filter.attribute)":"\(filter.value)"
    """
    let prefix = filter.isNegated ? negationPrefix : ""
    return prefix + expression
  }
  
  public static func transformFilter(_ filter: any Filter) -> String {
    switch filter {
    case let facet as FacetFilter:
      return transform(facet)
    case let numeric as NumericFilter:
      return transform(numeric)
    case let tag as TagFilter:
      return transform(tag)
    default:
      assertionFailure("Unexpected filter type: \(filter)")
      return ""
    }
  }
  
  public static func transform(_ filters: [any Filter], separator: FilterSeparator) -> String {
    if filters.isEmpty {
      return ""
    }
    return "( \(filters.map(transformFilter).sorted().joined(separator: separator.rawValue)) )"
  }
  
  public static func transform(_ group: AndFilterGroup) -> String {
    transform(group.filters, separator: .and)
  }
  
  public static func transform<F: Filter>(_ group: OrFilterGroup<F>) -> String {
    transform(group.filters, separator: .or)
  }
  
  public static func transform(_ group: HierarchicalFilterGroup) -> String {
    transform(group.filters, separator: .and)
  }
  
  public static func transformGroup(_ group: any FilterGroup) -> String {
    switch group {
    case let andGroup as AndFilterGroup:
      return transform(andGroup)
    case let orGroup as OrFilterGroup<FacetFilter>:
      return transform(orGroup)
    case let orGroup as OrFilterGroup<NumericFilter>:
      return transform(orGroup)
    case let orGroup as OrFilterGroup<TagFilter>:
      return transform(orGroup)
    case let hierarchicalGroup as HierarchicalFilterGroup:
      return transform(hierarchicalGroup)
    default:
      assertionFailure("Unexpected group type: \(group)")
      return ""
    }
  }
  
  public static func transform<S: Sequence>(_ groups: S, separator: FilterSeparator = .and) -> String where S.Element == any FilterGroup {
    groups.filter { !$0.filters.isEmpty }.map(transformGroup).sorted().joined(separator: separator.rawValue)
  }
  
  public static func transform(_ filters: Filters) -> String {
    transform(filters.groups.values, separator: .and)
  }
  
}
