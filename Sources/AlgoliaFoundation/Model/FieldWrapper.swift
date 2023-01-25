import Foundation

public struct FieldWrapper<Wrapped: Encodable>: Encodable {
  let key: String
  let wrapped: Wrapped

  init(key: String, _ wrapped: Wrapped) {
    self.key = key
    self.wrapped = wrapped
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CustomCodingKey.self)
    try container.encode(wrapped, forKey: CustomCodingKey(stringValue: key))
  }

  static func make(_ key: String) -> (Wrapped) -> Self {
    { wrapped in FieldWrapper(key: key, wrapped) }
  }

  public static func params(_ wrapped: Wrapped) -> Self { make("params")(wrapped) }
  public static func requests(_ wrapped: Wrapped) -> Self { make("requests")(wrapped) }
  public static func events(_ wrapped: Wrapped) -> Self { make("events")(wrapped) }
  public static func edits(_ wrapped: Wrapped) -> Self { make("edits")(wrapped) }
  public static func remove(_ wrapped: Wrapped) -> Self { make("remove")(wrapped) }
  public static func cluster(_ wrapped: Wrapped) -> Self { make("cluster")(wrapped) }
  public static func cursor(_ wrapped: Wrapped) -> Self { make("cursor")(wrapped) }
}
