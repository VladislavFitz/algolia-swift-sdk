import Foundation

public struct QueryID: StringOption {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}
