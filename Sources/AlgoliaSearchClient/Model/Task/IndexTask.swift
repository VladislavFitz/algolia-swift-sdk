import Foundation

public protocol IndexTask {
  var taskID: TaskID { get }
}

public extension IndexTask where Self: IndexContainer {
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
            pollingInterval _: TimeInterval = 1) async throws {
    guard let index = index else {
      throw WaitError.missingIndex
    }
    try await index.waitTask(withID: taskID,
                             timeoutInterval: timeoutInterval)
  }
}
