import AlgoliaFoundation
import Foundation
/**
 Associates a certain user token with the current search.
 - Engine default: User ip address
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/userToken/?language=swift)
 */
public struct UserToken: ValueRepresentable {
  static let key = "userToken"
  public var key: String { Self.key }
  public let value: String

  private let allowedCharacters: CharacterSet = CharacterSet.alphanumerics.union(.init(charactersIn: "._-"))

  public init(_ value: String) {
    assert(!value.isEmpty, "UserToken can't be empty")
    assert(value.count <= 64, "UserToken length can't be superior to 64 characters. Input: \(value)")
    let containsOnlyAllowedCharacters = value.trimmingCharacters(in: allowedCharacters).isEmpty
    assert(containsOnlyAllowedCharacters, "UserToken allows only characters of type [a-zA-Z0-9_-.]. Input: \(value)")
    self.value = value
  }
}

extension UserToken: SearchParameter {}

public extension SearchParameters {
  /**
   Associates a certain user token with the current search.
   - Engine default: User ip address
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/userToken/?language=swift)
   */
  var userToken: String? {
    get {
      (parameters[UserToken.key] as? UserToken)?.value
    }
    set {
      parameters[UserToken.key] = newValue.flatMap(UserToken.init)
    }
  }
}
