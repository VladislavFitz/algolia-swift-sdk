import AlgoliaFoundation
import Foundation

public struct ObjectCreation: Decodable, IndexTask, IndexContainer {
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
}
