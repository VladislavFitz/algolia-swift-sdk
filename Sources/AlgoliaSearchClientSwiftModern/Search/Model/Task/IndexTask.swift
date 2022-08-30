//
//  IndexTask.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public protocol IndexTask {
  var taskID: TaskID { get }
}

extension IndexTask where Self: IndexContainer {
  func wait(timeout: TimeInterval = 600) async throws {
    try await index!.waitTask(withID: taskID, timeout: timeout)
  }
}
