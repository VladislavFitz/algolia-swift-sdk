import Foundation

public protocol IndexTask {
  var taskID: TaskID { get }
}

extension IndexTask where Self: IndexContainer {
  func wait(timeout: TimeInterval = 600) async throws {
    guard let index = index else {
      throw WaitError.missingIndex
    }
    try await index.waitTask(withID: taskID, timeout: timeout)
  }
}
