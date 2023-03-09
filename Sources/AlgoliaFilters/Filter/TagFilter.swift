import AlgoliaFoundation
import Foundation

/** Defines tag filter
 # See also:
 [Reference](https:www.algolia.com/doc/guides/managing-results/refine-results/filtering/how-to/filter-by-tags/)
 */
public struct TagFilter: Filter, Hashable, Equatable {
  public let attribute: Attribute = "_tags"
  public var isNegated: Bool
  public let value: String

  public init(value: String, isNegated: Bool = false) {
    self.isNegated = isNegated
    self.value = value
  }
}

extension TagFilter: ExpressibleByStringLiteral {
  public typealias StringLiteralType = String

  public init(stringLiteral string: String) {
    self.init(value: string, isNegated: false)
  }
}

extension TagFilter: CustomStringConvertible {
  public var description: String {
    let expression = """
    "\(attribute)":"\(value)"
    """
    let prefix = isNegated ? "NOT " : ""
    return prefix + expression
  }
}
