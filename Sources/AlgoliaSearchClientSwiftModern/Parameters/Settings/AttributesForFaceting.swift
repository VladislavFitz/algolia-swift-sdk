import Foundation
/// The complete list of attributes that will be used for faceting.
public struct AttributesForFaceting: ValueRepresentable, SettingsParameter {
  static let key = "attributesForFaceting"
  public var key: String { Self.key }
  public let value: [AttributeForFaceting]

  public init(_ value: [AttributeForFaceting]) {
    self.value = value
  }
}

public extension SettingsParameters {
  /// The complete list of attributes that will be used for faceting.
  var attributesForFaceting: [AttributeForFaceting]? {
    get {
      (parameters[AttributesForFaceting.key] as? AttributesForFaceting)?.value
    }
    set {
      parameters[AttributesForFaceting.key] = newValue.flatMap(AttributesForFaceting.init)
    }
  }
}
