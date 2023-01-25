import Foundation

/// Concrete type box for an arbitrary encodable value
public struct EncodableBox: Encodable {
  public let value: Encodable

  public init(_ value: Encodable) {
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
}
