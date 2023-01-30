import AlgoliaFoundation
import Foundation

struct IndexOperation {
  let operation: Operation
  let destination: IndexName
}

extension IndexOperation {
  enum Operation {
    case copy(Scopes), move
  }
}

extension IndexOperation: Encodable {
  enum CodingKeys: String, CodingKey {
    case operation
    case destination
    case scope
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(destination, forKey: .destination)
    switch operation {
    case let .copy(scope):
      try container.encode("copy", forKey: .operation)
      try container.encode(scope.components, forKey: .scope)
    case .move:
      try container.encode("move", forKey: .operation)
    }
  }
}
