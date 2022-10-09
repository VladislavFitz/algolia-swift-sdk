//
//  Page.swift
//
//
//  Created by Vladislav Fitc on 08.08.2022.
//

import Foundation

struct Page {
  static let key = "page"
  let value: Int

  init(_ value: Int) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension Page: SearchParameter {
  var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  var page: Int? {
    get {
      (parameters[Page.key] as? Page)?.value
    }
    set {
      parameters[Page.key] = newValue.flatMap(Page.init)
    }
  }
}
