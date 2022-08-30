//
//  HTTPStatusCode.swift
//
//
//  Created by Vladislav Fitc on 11.08.2022.
//

import Foundation

public typealias HTTPStatusСode = Int

extension HTTPStatusСode {
  static let notFound: HTTPStatusСode = 404
  static let requestTimeout: HTTPStatusСode = 408
  static let tooManyRequests: HTTPStatusСode = 429

  func belongs(to categories: HTTPStatusCategory...) -> Bool {
    return categories.map { $0.contains(self) }.contains(true)
  }

  var isError: Bool {
    return belongs(to: .clientError, .serverError)
  }
}
