//
//  HTTPStatusCategory.swift
//
//
//  Created by Vladislav Fitc on 11.08.2022.
//

import Foundation

enum HTTPStatusCategory {
  case informational
  case success
  case redirection
  case clientError
  case serverError

  func contains(_ statusCode: HTTPStatusСode) -> Bool {
    return range.contains(statusCode)
  }

  var range: Range<Int> {
    switch self {
    case .informational:
      return 100 ..< 200
    case .success:
      return 200 ..< 300
    case .redirection:
      return 300 ..< 400
    case .clientError:
      return 400 ..< 500
    case .serverError:
      return 500 ..< 600
    }
  }
}
