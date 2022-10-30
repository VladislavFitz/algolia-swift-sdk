import Foundation

internal struct FieldWrapper<Wrapped: Encodable>: Encodable {
  
  let key: String
  let wrapped: Wrapped

  init(key: String, _ wrapped: Wrapped) {
    self.key = key
    self.wrapped = wrapped
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: DynamicKey.self)
    try container.encode(wrapped, forKey: DynamicKey(stringValue: key))
  }
  
  static func make(_ key: String) -> (Wrapped) -> Self {
    { wrapped in FieldWrapper(key: key, wrapped) }
  }
  
  static func params(_ wrapped: Wrapped) -> Self { make("params")(wrapped) }
  static func requests(_ wrapped: Wrapped) -> Self { make("requests")(wrapped) }
  static func events(_ wrapped: Wrapped) -> Self { make("events")(wrapped) }
  static func edits(_ wrapped: Wrapped) -> Self { make("edits")(wrapped) }
  static func remove(_ wrapped: Wrapped) -> Self { make("remove")(wrapped) }
  static func cluster(_ wrapped: Wrapped) -> Self { make("cluster")(wrapped) }
  static func cursor(_ wrapped: Wrapped) -> Self { make("cursor")(wrapped) }
  
}
