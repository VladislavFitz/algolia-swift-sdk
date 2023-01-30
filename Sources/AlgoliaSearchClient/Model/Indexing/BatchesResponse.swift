import AlgoliaFoundation
import Foundation

public struct BatchesResponse {
  /// A list of TaskIndex to use with .waitAll.
  public let tasks: [IndexedTask]

  /// List of ObjectID affected by .multipleBatchObjects.
  public let objectIDs: [ObjectID?]
}

public extension BatchesResponse {
  init(indexName: IndexName, responses: [BatchResponse]) {
    let tasks: [IndexedTask] = responses.map { .init(indexName: indexName,
                                                     taskID: $0.taskID,
                                                     index: $0.index) }
    let objectIDs = responses.map(\.objectIDs).flatMap { $0 }
    self.init(tasks: tasks, objectIDs: objectIDs)
  }
}

public extension BatchesResponse {
  /**
     Wait for a IndexTask to complete before executing the next line of code, to synchronize index updates.
     All write operations in Algolia are asynchronous by design.
     It means that when you add or update an object to your index, our servers will reply to your request with
     a TaskID as soon as they understood the write operation.
     The actual insert and indexing will be done after replying to your code.
     You can wait for a task to complete by using the TaskID and this method.

    - parameter timeoutInterval: the max time interval to wait for `published` task status response.
      If the timeout exceeded, throws the WaitError.timeoutExceeded error.
    - parameter pollingInterval: the time interval between two `taskStatus` requests.
   */
  func wait(timeoutInterval: TimeInterval = 600,
            pollingInterval: TimeInterval = 1) async throws {
    for task in tasks {
      try await task.wait(timeoutInterval: timeoutInterval,
                          pollingInterval: pollingInterval)
    }
  }
}
