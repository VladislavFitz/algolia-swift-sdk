import Foundation

/// The complete list of attributes that will be used for searching.
public struct SearchableAttributes: SettingsParameter {
  public static let key = "searchableAttributes"
  public var key: String { Self.key }
  public let value: [SearchableAttribute]

  init(_ value: [SearchableAttribute]) {
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension SettingsParameters {
  /// The complete list of attributes that will be used for searching.
  var searchableAttributes: [SearchableAttribute]? {
    get {
      (parameters[SearchableAttributes.key] as? SearchableAttributes)?.value
    }
    set {
      parameters[SearchableAttributes.key] = newValue.flatMap(SearchableAttributes.init)
    }
  }
}
