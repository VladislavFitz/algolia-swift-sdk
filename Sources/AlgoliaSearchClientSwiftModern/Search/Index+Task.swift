//
//  Index+Task.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public extension Index {
  @discardableResult func taskStatus(for taskID: TaskID) async throws -> TaskInfo {
    let responseData = try await client.transport.perform(method: .get,
                                                          path: "/1/indexes/\(indexName.rawValue)/task/\(taskID)",
                                                          headers: [:],
                                                          body: nil,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(TaskInfo.self, from: responseData)
  }

  @discardableResult func waitTask(withID taskID: TaskID, timeout: TimeInterval = 600) async throws -> TaskStatus {
    let launchDate = Date()
    while Date().timeIntervalSince(launchDate) < timeout {
      let status = try await taskStatus(for: taskID)
      if status.status == .published {
        return status.status
      }
      sleep(1)
    }
    return .notPublished
  }
}
