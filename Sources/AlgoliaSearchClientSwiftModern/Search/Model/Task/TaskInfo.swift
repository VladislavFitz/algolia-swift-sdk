import Foundation

/// The information about the server task
public struct TaskInfo: Decodable {
  /// The Task current TaskStatus.
  public let status: TaskStatus

  /// Whether the index has remaining  running Task
  public let pendingTask: Bool
}
