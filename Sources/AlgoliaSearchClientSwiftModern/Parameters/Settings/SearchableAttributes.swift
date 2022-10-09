//
//  SearchableAttributes.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

import Foundation

/// The complete list of attributes that will be used for searching.
struct SearchableAttributes: SettingsParameter {
  static let key = "searchableAttributes"
  let value: [SearchableAttribute]

  init(_ value: [SearchableAttribute]) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
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
