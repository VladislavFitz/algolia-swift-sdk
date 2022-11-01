import Foundation

public struct BatchResponse: Decodable, IndexTask, IndexContainer {
  /// The list of object ids involved in  the batch method
  public let objectIDs: [ObjectID?]

  /// The TaskID which can be used with the .waitTask method.
  public let taskID: TaskID

  internal var index: Index?

  enum CodingKeys: CodingKey {
    case taskID, objectIDs
  }
}
