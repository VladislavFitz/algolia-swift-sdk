import Foundation

public struct BatchesResponse {
  /// A list of TaskIndex to use with .waitAll.
  public let tasks: [IndexedTask]

  /// List of ObjectID affected by .multipleBatchObjects.
  public let objectIDs: [ObjectID?]
}

extension BatchesResponse {
  init(indexName: IndexName, responses: [BatchResponse]) {
    let tasks: [IndexedTask] = responses.map { .init(indexName: indexName, taskID: $0.taskID) }
    let objectIDs = responses.map(\.objectIDs).flatMap { $0 }
    self.init(tasks: tasks, objectIDs: objectIDs)
  }
}

extension BatchesResponse {
  func wait(timeout: TimeInterval = 600) async throws {
    for task in tasks {
      try await task.wait(timeout: timeout)
    }
  }
}
