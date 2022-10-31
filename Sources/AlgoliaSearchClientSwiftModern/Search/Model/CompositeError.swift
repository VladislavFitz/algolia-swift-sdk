import Foundation

public struct CompositeError: Error {
  public let errors: [Error]

  public init(errors: [Error]) {
    self.errors = errors
  }

  public static func from(_ errors: Error...) -> Self {
    CompositeError(errors: errors)
  }
}
