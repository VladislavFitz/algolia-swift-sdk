import Foundation
// swiftlint:disable identifier_name

public struct Region {
  public static var us: Self { .init(rawValue: #function) }

  /// European (Germany) region for Insights and Analytics APIs
  public static var de: Self { .init(rawValue: #function) }

  /// European region for Personalization API
  public static var eu: Self { .init(rawValue: #function) }

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}
