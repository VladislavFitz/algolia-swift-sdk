import Foundation
/**
 Specify the offset of the first hit to return.
 - Engine default: null
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/offset/?language=swift)
 */
public struct Offset: ValueRepresentable {
  static let key = "offset"
  public var key: String { Self.key }
  public let value: Int

  public init(_ value: Int) {
    self.value = value
  }
}

extension Offset: SearchParameter {}

public extension SearchParameters {
  /**
   Specify the offset of the first hit to return.
   - Engine default: null
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/offset/?language=swift)
   */
  var offset: Int? {
    get {
      (parameters[Offset.key] as? Offset)?.value
    }
    set {
      parameters[Offset.key] = newValue.flatMap(Offset.init)
    }
  }
}
