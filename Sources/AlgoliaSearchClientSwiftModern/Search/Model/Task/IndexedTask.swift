import Foundation

public struct IndexedTask: IndexTask, IndexContainer {
  /// The name of the index this task is running on.
  public let indexName: IndexName

  /// The TaskID which can be used with the .waitTask method.
  public let taskID: TaskID

  internal var index: Index?

  enum CodingKeys: CodingKey {
    case indexName, taskID
  }
}
