//
//  SettingsParameters.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

import Foundation

public struct SettingsParameters {
  internal var parameters: [String: SettingsParameter]

  public init(_ parameters: [SettingsParameter]) {
    self.parameters = .init(uniqueKeysWithValues: parameters.map { (type(of: $0).key, $0) })
  }

  public init(_ parameters: SettingsParameter...) {
    self.init(parameters)
  }

  public init(@SettingsParametersBuilder _ content: () -> [SettingsParameter]) {
    self = SettingsParameters(content())
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
