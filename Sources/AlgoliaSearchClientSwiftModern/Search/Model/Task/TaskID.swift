import Foundation

/// The identifier of the server task
public struct TaskID: StringWrapper {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}
