import AlgoliaFoundation
import Foundation

public struct IndexDeletion: Decodable, IndexTask, IndexContainer {
  /// Date at which the Task to delete the Index has been created.
  public let deletedAt: Date

  /// The TaskID which can be used with the .waitTask method.
  public let taskID: TaskID

  public var index: Index?

  enum CodingKeys: CodingKey {
    case deletedAt, taskID
  }
}
