import AlgoliaFoundation
import Foundation

public struct TestRecord: Codable, Equatable, Hashable, CustomStringConvertible {
  public var objectID: ObjectID?
  public var string: String
  public var numeric: Int
  public var bool: Bool
  public var tags: [String]?

  public init(objectID: ObjectID? = nil,
              string: String? = nil,
              numeric: Int? = nil,
              bool: Bool? = nil,
              tags: [String]? = nil) {
    self.objectID = objectID
    self.string = string ?? .random(length: .random(in: 1 ..< 100))
    self.numeric = numeric ?? .random(in: 1 ..< 100)
    self.bool = bool ?? .random()
    self.tags = tags
  }

  public static func withGeneratedObjectID() -> Self {
    return Self(objectID: ObjectID(rawValue: .random(length: 10)))
  }

  public var description: String {
    return [objectID.flatMap { "objectID: \($0)" },
            "string: \(string)",
            "numeric: \(numeric)",
            "bool: \(bool)",
            tags.flatMap { "tags: \($0)" }].compactMap { $0 }.joined(separator: ", ")
  }
}
