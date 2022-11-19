import Foundation
/// The complete list of attributes that will be used for searching.
public struct SearchableAttributes: ValueRepresentable, SettingsParameter {
  public static let key = "searchableAttributes"
  public var key: String { Self.key }
  public let value: [SearchableAttribute]

  public init(_ value: [SearchableAttribute]) {
    self.value = value
  }
}

public extension SettingsParameters {
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
