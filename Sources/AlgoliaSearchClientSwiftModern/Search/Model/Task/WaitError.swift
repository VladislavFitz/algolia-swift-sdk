import Foundation

/// Error which occurs during
/// the waiting for task accomplishment
enum WaitError: LocalizedError {
  case timeoutExceeded
  case missingIndex
  case missingClient

  var errorDescription: String? {
    switch self {
    case .timeoutExceeded:
      return "The wait operation timeout exceeded"
    case .missingIndex:
      return "Task structure has nil index reference to launch wait on"
    case .missingClient:
      return "Task structure has nil client reference to launch wait on"
    }
  }
}
