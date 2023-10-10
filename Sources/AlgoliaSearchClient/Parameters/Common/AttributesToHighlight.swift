import AlgoliaFoundation
import Foundation
/**
 List of attributes to highlight.
 - Engine default: ["*"]
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToHighlight/?language=swift)
 */
public struct AttributesToHighlight: ValueRepresentable {
  static let key = "attributesToHighlight"
  public var key: String { Self.key }
  public let value: [Attribute]

  public init(_ value: [Attribute]) {
    self.value = value
  }
}

extension AttributesToHighlight: SearchParameter {}

public extension SearchParameters {
  /**
   List of attributes to highlight.
   - Engine default: ["*"]
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToHighlight/?language=swift)
   */
  var attributesToHighlight: [Attribute]? {
    get {
      (parameters[AttributesToHighlight.key] as? AttributesToHighlight)?.value
    }
    set {
      parameters[AttributesToHighlight.key] = newValue.flatMap(AttributesToHighlight.init)
    }
  }
}

extension AttributesToHighlight: SettingsParameter {}

public extension SettingsParameters {
  /**
   List of attributes to highlight.
   - Engine default: ["*"]
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToHighlight/?language=swift)
   */
  var attributesToHighlight: [Attribute]? {
    get {
      (parameters[AttributesToHighlight.key] as? AttributesToHighlight)?.value
    }
    set {
      parameters[AttributesToHighlight.key] = newValue.flatMap(AttributesToHighlight.init)
    }
  }
}

