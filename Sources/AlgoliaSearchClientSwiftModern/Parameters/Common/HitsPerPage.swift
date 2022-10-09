//
//  HitsPerPage.swift
//
//
//  Created by Vladislav Fitc on 08.08.2022.
//

import Foundation

struct HitsPerPage {
  static let key = "hitsPerPage"
  let value: Int

  init(_ value: Int) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension HitsPerPage: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  var hitsPerPage: Int? {
    get {
      (parameters[HitsPerPage.key] as? HitsPerPage)?.value
    }
    set {
      parameters[HitsPerPage.key] = newValue.flatMap(HitsPerPage.init)
    }
  }
}

extension HitsPerPage: SettingsParameter {}

extension SettingsParameters {
  var hitsPerPage: Int? {
    get {
      (parameters[HitsPerPage.key] as? HitsPerPage)?.value
    }
    set {
      parameters[HitsPerPage.key] = newValue.flatMap(HitsPerPage.init)
    }
  }
}
