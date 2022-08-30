//
//  ObjectCreation.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public struct ObjectCreation: IndexTask, Decodable {
  /// The date at which the record has been created.
  public let createdAt: Date

  /// The TaskID which can be used with the [EndpointAdvanced.waitTask] method.
  public let taskID: TaskID

  /// The inserted record ObjectID
  public let objectID: ObjectID

  internal var index: Index?

  enum CodingKeys: CodingKey {
    case createdAt, taskID, objectID
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    createdAt = try container.decode(Date.self, forKey: .createdAt)
    taskID = try container.decode(TaskID.self, forKey: .taskID)
    objectID = try container.decode(ObjectID.self, forKey: .objectID)
  }
}

extension ObjectCreation: IndexContainer {}
