import Foundation

public struct BatchResponse: Decodable, IndexTask, IndexContainer {
  public let taskID: TaskID

  public let objectIDs: [ObjectID?]

  internal var index: Index?

  enum CodingKeys: CodingKey {
    case taskID, objectIDs
  }
}
