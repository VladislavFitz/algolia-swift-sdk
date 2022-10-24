//
//  AttributesForFaceting.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

import Foundation
/// The complete list of attributes that will be used for faceting.
struct AttributesForFaceting: SettingsParameter {
  static let key = "attributesForFaceting"
  var key: String { Self.key }
  let value: [AttributeForFaceting]

  init(_ value: [AttributeForFaceting]) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension SettingsParameters {
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
