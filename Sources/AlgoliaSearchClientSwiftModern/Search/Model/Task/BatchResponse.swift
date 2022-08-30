//
//  BatchResponse.swift
//
//
//  Created by Vladislav Fitc on 02.09.2022.
//

import Foundation

public struct BatchResponse: Decodable, IndexTask, IndexContainer {
  public let taskID: TaskID
  public let objectIDs: [ObjectID?]
  internal var index: Index?

  enum CodingKeys: CodingKey {
    case taskID, objectIDs
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    taskID = try container.decode(TaskID.self, forKey: .taskID)
    objectIDs = try container.decode([ObjectID?].self, forKey: .objectIDs)
  }
}
