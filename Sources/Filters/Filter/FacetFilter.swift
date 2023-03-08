import Foundation
import AlgoliaFoundation

//swiftlint:disable line_length
/** Defines facet filter
- SeeAlso:
  - [Filter by string](https://algolia.com/doc/guides/managing-results/refine-results/filtering/how-to/filter-by-string/)
  - [Filter by boolean](https://algolia.com/doc/guides/managing-results/refine-results/filtering/how-to/filter-by-boolean/)
*/
public struct FacetFilter: Filter, Hashable, Equatable {
//swiftlint:enable line_length
  public let attribute: Attribute
  public let value: ValueType
  public var isNegated: Bool
  public let score: Int?

  public init(attribute: Attribute, value: ValueType, isNegated: Bool = false, score: Int? = nil) {
    self.attribute = attribute
    self.isNegated = isNegated
    self.value = value
    self.score = score
  }

  public init(attribute: Attribute, stringValue: String, isNegated: Bool = false) {
    self.init(attribute: attribute, value: .string(stringValue), isNegated: isNegated)
  }

  public init(attribute: Attribute, floatValue: Float, isNegated: Bool = false) {
    self.init(attribute: attribute, value: .float(floatValue), isNegated: isNegated)
  }

  public init(attribute: Attribute, boolValue: Bool, isNegated: Bool = false) {
    self.init(attribute: attribute, value: .bool(boolValue), isNegated: isNegated)
  }

}

extension FacetFilter: RawRepresentable {

  public typealias RawValue = (Attribute, ValueType)

  public init?(rawValue: (Attribute, FacetFilter.ValueType)) {
    self.init(attribute: rawValue.0, value: rawValue.1)
  }

  public var rawValue: (Attribute, FacetFilter.ValueType) {
    return (attribute, value)
  }

}

extension FacetFilter: CustomStringConvertible {

  public var description: String {
    let scoreExpression = score.flatMap { "<score=\(String($0))>" } ?? ""
    let expression = """
    "\(attribute)":"\(value)\(scoreExpression)"
    """
    let prefix = isNegated ? "NOT " : ""
    return prefix + expression
  }

}

extension FacetFilter {

  public enum ValueType: CustomStringConvertible, Hashable {

    case string(String)
    case float(Float)
    case bool(Bool)

    public var description: String {
      switch self {
      case .string(let value):
        return value
      case .bool(let value):
        return "\(value)"
      case .float(let value):
        return "\(value)"
      }
    }

  }

}

extension FacetFilter.ValueType: ExpressibleByBooleanLiteral {

  public typealias BooleanLiteralType = Bool

  public init(booleanLiteral value: BooleanLiteralType) {
    self = .bool(value)
  }

}

extension FacetFilter.ValueType: ExpressibleByFloatLiteral {

  public typealias FloatLiteralType = Float

  public init(floatLiteral value: FloatLiteralType) {
    self = .float(value)
  }

}

extension FacetFilter.ValueType: ExpressibleByStringLiteral {

  public typealias StringLiterlalType = String

  public init(stringLiteral value: StringLiteralType) {
    self = .string(value)
  }

}

extension FacetFilter.ValueType: ExpressibleByIntegerLiteral {

  public typealias IntegerLiteralType = Int

  public init(integerLiteral value: IntegerLiteralType) {
    self = .float(Float(value))
  }

}
