//
//  TestObject.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

@testable import AlgoliaSearchClientSwiftModern
import Foundation

struct TestRecord: Codable, Equatable, CustomStringConvertible {
  var objectID: ObjectID?
  var string: String
  var numeric: Int
  var bool: Bool
  var tags: [String]?

  init(objectID: String) {
    self.init(objectID: .init(rawValue: objectID))
  }

  init(objectID: ObjectID? = nil) {
    self.objectID = objectID
    string = .random(length: .random(in: 1 ..< 100))
    numeric = .random(in: 1 ..< 100)
    bool = .random()
  }

  static func withGeneratedObjectID() -> Self {
    return Self(objectID: .random(length: 10))
  }

  var description: String {
    return [objectID.flatMap { "objectID: \($0)" },
            "string: \(string)",
            "numeric: \(numeric)",
            "bool: \(bool)",
            tags.flatMap { "tags: \($0)" }].compactMap { $0 }.joined(separator: ", ")
  }
}
