//
//  TestObject.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

@testable import AlgoliaSearchClientSwiftModern
import Foundation

struct TestRecord: Codable, Equatable, Hashable, CustomStringConvertible {
  var objectID: ObjectID?
  var string: String
  var numeric: Int
  var bool: Bool
  var tags: [String]?

  init(objectID: ObjectID? = nil,
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

  static func withGeneratedObjectID() -> Self {
    return Self(objectID: ObjectID(rawValue: .random(length: 10)))
  }

  var description: String {
    return [objectID.flatMap { "objectID: \($0)" },
            "string: \(string)",
            "numeric: \(numeric)",
            "bool: \(bool)",
            tags.flatMap { "tags: \($0)" }].compactMap { $0 }.joined(separator: ", ")
  }
}
