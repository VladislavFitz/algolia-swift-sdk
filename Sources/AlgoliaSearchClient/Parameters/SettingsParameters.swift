import AlgoliaFoundation
import Foundation

public struct SettingsParameters {
  internal var parameters: [String: SettingsParameter]

  public init(_ parameters: [SettingsParameter]) {
    self.parameters = .init(uniqueKeysWithValues: parameters.map { ($0.key, $0) })
  }

  public init(_ parameters: SettingsParameter...) {
    self.init(parameters)
  }

  public init(@SettingsParametersBuilder _ content: () -> [SettingsParameter]) {
    self = Self(content())
  }
}

extension SettingsParameters: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CustomCodingKey.self)
    for (key, parameter) in parameters {
      try container.encode(EncodableBox(parameter), forKey: CustomCodingKey(stringValue: key))
    }
  }
}
