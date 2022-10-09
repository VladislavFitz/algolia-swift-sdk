//
//  AttributesForFaceting.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

import Foundation

struct AttributesForFaceting: SettingsParameter {
  static let key = "attributesForFaceting"
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
  var attributesForFaceting: [AttributeForFaceting]? {
    get {
      (parameters[AttributesForFaceting.key] as? AttributesForFaceting)?.value
    }
    set {
      parameters[AttributesForFaceting.key] = newValue.flatMap(AttributesForFaceting.init)
    }
  }
}
