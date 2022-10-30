import Foundation

public struct ObjectDeletion: IndexTask, Codable {
  /// The date at which the record has been deleted.
  public let deletedAt: Date

  /// The TaskID which can be used with the waitTask method.
  public let taskID: TaskID

  /// The deleted record ObjectID
  public let objectID: ObjectID

  internal var index: Index?

  enum CodingKeys: CodingKey {
    case deletedAt, taskID, objectID
  }
}

extension ObjectDeletion: IndexContainer {}
