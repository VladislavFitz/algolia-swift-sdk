import AlgoliaFoundation
import Foundation
/**
 List of attributes to snippet, with an optional maximum number of words to snippet.
 - Engine default: ["*"]
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToSnippet/?language=swift)
 */
public struct AttributesToSnippet: ValueRepresentable {
  static let key = "attributesToSnippet"
  public var key: String { Self.key }
  public let value: [Attribute]

  public init(_ value: [Attribute]) {
    self.value = value
  }
}

extension AttributesToSnippet: SearchParameter {}

public extension SearchParameters {
  /**
   List of attributes to snippet, with an optional maximum number of words to snippet.
   - Engine default: ["*"]
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToSnippet/?language=swift)
   */
  var attributesToSnippet: [Attribute]? {
    get {
      (parameters[AttributesToSnippet.key] as? AttributesToSnippet)?.value
    }
    set {
      parameters[AttributesToSnippet.key] = newValue.flatMap(AttributesToSnippet.init)
    }
  }
}

extension AttributesToSnippet: SettingsParameter {}

public extension SettingsParameters {
  /**
   List of attributes to snippet, with an optional maximum number of words to snippet.
   - Engine default: ["*"]
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToSnippet/?language=swift)
   */
  var attributesToSnippet: [Attribute]? {
    get {
      (parameters[AttributesToSnippet.key] as? AttributesToSnippet)?.value
    }
    set {
      parameters[AttributesToSnippet.key] = newValue.flatMap(AttributesToSnippet.init)
    }
  }
}

