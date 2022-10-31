import Foundation

/// Concrete type box for an arbitrary encodable value
struct EncodableBox: Encodable {
  let value: Encodable

  init(_ value: Encodable) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
}
