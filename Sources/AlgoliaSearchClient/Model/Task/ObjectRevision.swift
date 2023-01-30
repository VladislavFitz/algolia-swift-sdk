import AlgoliaFoundation
import Foundation

public struct ObjectRevision: Decodable, IndexTask, IndexContainer {
  /// The date at which the record has been revised.
  public let updatedAt: Date

  /// The TaskID which can be used with the waitTask method.
  public let taskID: TaskID

  /// The inserted record ObjectID
  public let objectID: ObjectID

  public var index: Index?

  enum CodingKeys: CodingKey {
    case updatedAt, taskID, objectID
  }
}
