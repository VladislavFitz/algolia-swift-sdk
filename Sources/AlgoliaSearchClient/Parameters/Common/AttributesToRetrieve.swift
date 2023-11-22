import AlgoliaFoundation
import Foundation
/**
 List of attributes to retrieve.
 - Engine default: ["*"]
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToRetrieve/?language=swift)
 */
public struct AttributesToRetrieve: ValueRepresentable {
  static let key = "attributesToRetrieve"
  public var key: String { Self.key }
  public let value: [Attribute]

  public init(_ value: [Attribute]) {
    self.value = value
  }
}

extension AttributesToRetrieve: SearchParameter {}

public extension SearchParameters {
  /**
   List of attributes to retrieve.
   - Engine default: ["*"]
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToRetrieve/?language=swift)
   */
  var attributesToRetrieve: [Attribute]? {
    get {
      (parameters[AttributesToRetrieve.key] as? AttributesToRetrieve)?.value
    }
    set {
      parameters[AttributesToRetrieve.key] = newValue.flatMap(AttributesToRetrieve.init)
    }
  }
}

extension AttributesToRetrieve: SettingsParameter {}

public extension SettingsParameters {
  /**
   List of attributes to retrieve.
   - Engine default: ["*"]
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesToRetrieve/?language=swift)
   */
  var attributesToRetrieve: [Attribute]? {
    get {
      (parameters[AttributesToRetrieve.key] as? AttributesToRetrieve)?.value
    }
    set {
      parameters[AttributesToRetrieve.key] = newValue.flatMap(AttributesToRetrieve.init)
    }
  }
}
