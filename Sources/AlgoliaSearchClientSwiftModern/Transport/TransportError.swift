//
//  TransportError.swift
//
//
//  Created by Vladislav Fitc on 11.08.2022.
//

import Foundation

enum TransportError: Error, LocalizedError {
  case noReachableHosts
  case nonRetryableError(Error)

  var errorDescription: String? {
    switch self {
    case .noReachableHosts:
      return "No reachable hosts"
    case let .nonRetryableError(error):
      return "Non-retryable error: \(error.localizedDescription)"
    }
  }
}
