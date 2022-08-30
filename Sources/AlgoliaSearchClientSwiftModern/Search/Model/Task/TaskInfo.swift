//
//  TaskInfo.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public struct TaskInfo: Decodable {
  /// The Task current TaskStatus.
  public let status: TaskStatus

  /// Whether the index has remaining Task is running
  public let pendingTask: Bool
}
