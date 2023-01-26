import Foundation

public struct IndexRevision: Decodable, IndexTask, IndexContainer {
  /// Date at which the Task to update the Index has been created.
  public let updatedAt: Date

  /// The TaskID which can be used with the .waitTask method.
  public let taskID: TaskID

  public var index: Index?

  enum CodingKeys: CodingKey {
    case updatedAt, taskID
  }
}
