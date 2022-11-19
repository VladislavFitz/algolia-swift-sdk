import Foundation

public struct CustomParameter {
  public let key: String
  public let value: JSON

  public init(key: String, _ value: JSON) {
    self.key = key
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension CustomParameter: SearchParameter {
  public var urlEncodedString: String {
    ""
  }
}

extension CustomParameter: SettingsParameter {}
