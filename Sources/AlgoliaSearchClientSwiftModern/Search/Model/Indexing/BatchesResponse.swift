//
//  BatchesResponse.swift
//
//
//  Created by Vladislav Fitc on 02.09.2022.
//

import Foundation

public struct BatchesResponse {
  /// A list of TaskIndex to use with .waitAll.
  public let tasks: [BatchResponse]

  /// List of ObjectID affected by .multipleBatchObjects.
  public let objectIDs: [ObjectID?]
}

extension BatchesResponse {
  init(indexName _: IndexName, responses: [BatchResponse]) {
    let objectIDs = responses.map(\.objectIDs).flatMap { $0 }
    self.init(tasks: responses, objectIDs: objectIDs)
  }
}

extension BatchesResponse {
  func wait(timeout: TimeInterval = 600) async throws {
    for task in tasks {
      try await task.wait(timeout: timeout)
    }
  }
}
