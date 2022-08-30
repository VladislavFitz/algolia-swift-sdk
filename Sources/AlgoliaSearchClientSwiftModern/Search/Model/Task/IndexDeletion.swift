//
//  IndexDeletion.swift
//
//
//  Created by Vladislav Fitc on 29.08.2022.
//

import Foundation

public struct IndexDeletion: IndexTask, Decodable {
  /// Date at which the Task to delete the Index has been created.
  public let deletedAt: Date

  /// The TaskID which can be used with the .waitTask method.
  public let taskID: TaskID

  internal var index: Index?

  enum CodingKeys: CodingKey {
    case deletedAt, taskID
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    deletedAt = try container.decode(Date.self, forKey: .deletedAt)
    taskID = try container.decode(TaskID.self, forKey: .taskID)
  }
}

extension IndexDeletion: IndexContainer {}
