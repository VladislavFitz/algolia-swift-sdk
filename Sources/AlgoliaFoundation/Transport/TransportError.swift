import Foundation

public enum TransportError: Error, LocalizedError {
  case noReachableHosts
  case nonRetryableError(Error)

  public var errorDescription: String? {
    switch self {
    case .noReachableHosts:
      return "No reachable hosts"
    case let .nonRetryableError(error):
      return "Non-retryable error: \(error.localizedDescription)"
    }
  }
}
