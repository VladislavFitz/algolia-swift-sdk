//
//  Query.swift
//
//
//  Created by Vladislav Fitc on 08.08.2022.
//

import Foundation

struct Query {
  static let key = "query"
  let value: String

  init(_ value: String) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension Query: SearchParameter {
  var urlEncodedString: String {
    return value
  }
}

extension SearchParameters {
  var query: String? {
    get {
      (parameters[Query.key] as? Query)?.value
    }
    set {
      parameters[Query.key] = newValue.flatMap(Query.init)
    }
  }
}
