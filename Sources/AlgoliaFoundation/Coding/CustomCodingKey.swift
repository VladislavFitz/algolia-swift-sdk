import Foundation

/// Coding key encapsulating an arbitrary string
public struct CustomCodingKey: CodingKey {
  public let stringValue: String

  public var intValue: Int? {
    return Int(stringValue)
  }

  public init(stringValue: String) {
    self.stringValue = stringValue
  }

  public init?(intValue: Int) {
    stringValue = String(intValue)
  }
}
