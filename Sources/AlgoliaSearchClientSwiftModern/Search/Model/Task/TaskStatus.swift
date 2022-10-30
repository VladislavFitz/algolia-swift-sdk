import Foundation

public struct TaskStatus: RawRepresentable, Decodable {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// The Task has been processed by the server.
  public static var published: Self { .init(rawValue: #function) }

  /// The Task has not yet been processed by the server.
  public static var notPublished: Self { .init(rawValue: #function) }
}
