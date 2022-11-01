import Foundation

public extension Index {
  /**
    Check the current TaskStatus of a given IndexTask.

    - parameter taskID: of the indexing [IndexTask].
    - Returns: TaskInfo structure
   */
  @discardableResult func taskStatus(for taskID: TaskID) async throws -> TaskInfo {
    let responseData = try await client.transport.perform(method: .get,
                                                          path: "/1/indexes/\(indexName.rawValue)/task/\(taskID)",
                                                          headers: [:],
                                                          body: nil,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(TaskInfo.self, from: responseData)
  }

  /**
     Wait for a IndexTask to complete before executing the next line of code, to synchronize index updates.
     All write operations in Algolia are asynchronous by design.
     It means that when you add or update an object to your index, our servers will reply to your request with
     a TaskID as soon as they understood the write operation.
     The actual insert and indexing will be done after replying to your code.
     You can wait for a task to complete by using the TaskID and this method.

    - parameter taskID: task ID of the indexing task to wait for.
    - parameter timeoutInterval: the max time interval to wait for `published` task status response.
      If the timeout exceeded, throws the WaitError.timeoutExceeded error.
    - parameter pollingInterval: the time interval between two `taskStatus` requests.
   */
  func waitTask(withID taskID: TaskID,
                timeoutInterval: TimeInterval = 600,
                pollingInterval: TimeInterval = 1) async throws {
    let launchDate = Date()
    while Date().timeIntervalSince(launchDate) < timeoutInterval {
      let status = try await taskStatus(for: taskID)
      if status.status == .published {
        return
      }
      sleep(UInt32(pollingInterval))
    }
    throw WaitError.timeoutExceeded
  }
}
