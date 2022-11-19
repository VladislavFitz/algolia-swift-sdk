import Foundation
/**
 Search inside a rectangular area (in geo coordinates).
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insideBoundingBox/?language=swift)
 */
public struct InsideBoundingBox: ValueRepresentable {
  static let key = "insideBoundingBox"
  public var key: String { Self.key }
  public let value: [BoundingBox]

  public init(_ value: [BoundingBox]) {
    self.value = value
  }
}

extension InsideBoundingBox: SearchParameter {}

public extension SearchParameters {
  /**
   Search inside a rectangular area (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insideBoundingBox/?language=swift)
   */
  var insideBoundingBox: [BoundingBox]? {
    get {
      (parameters[InsideBoundingBox.key] as? InsideBoundingBox)?.value
    }
    set {
      parameters[InsideBoundingBox.key] = newValue.flatMap(InsideBoundingBox.init)
    }
  }
}

extension InsideBoundingBox: DeleteQueryParameter {}

public extension DeleteQueryParameters {
  /**
   Search inside a rectangular area (in geo coordinates).
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/insideBoundingBox/?language=swift)
   */
  var insideBoundingBox: [BoundingBox]? {
    get {
      (parameters[InsideBoundingBox.key] as? InsideBoundingBox)?.value
    }
    set {
      parameters[InsideBoundingBox.key] = newValue.flatMap(InsideBoundingBox.init)
    }
  }
}
