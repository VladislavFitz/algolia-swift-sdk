import AlgoliaFoundation
import Foundation

public struct Attribute: StringWrapper {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}
