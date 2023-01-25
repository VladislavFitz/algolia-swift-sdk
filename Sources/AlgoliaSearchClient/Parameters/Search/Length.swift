import AlgoliaFoundation
import Foundation
/**
 Set the number of hits to retrieve (used only with offset).
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/length/?language=swift)
 */
public struct Length: ValueRepresentable {
  static let key = "length"
  public var key: String { Self.key }
  public let value: Int

  public init(_ value: Int) {
    self.value = value
  }
}

extension Length: SearchParameter {}

public extension SearchParameters {
  /**
   Set the number of hits to retrieve (used only with offset).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/length/?language=swift)
   */
  var length: Int? {
    get {
      (parameters[Length.key] as? Length)?.value
    }
    set {
      parameters[Length.key] = newValue.flatMap(Length.init)
    }
  }
}
