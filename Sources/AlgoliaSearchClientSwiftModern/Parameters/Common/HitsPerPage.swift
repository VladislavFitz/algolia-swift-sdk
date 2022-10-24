import Foundation
/**
 Set the number of hits per page.
 - Engine default: 20
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/hitsPerPage/?language=swift)
 */
public struct HitsPerPage {
  static let key = "hitsPerPage"
  public var key: String { HitsPerPage.key }
  public let value: Int

  public init(_ value: Int) {
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension HitsPerPage: SearchParameter {
  public var urlEncodedString: String {
    return "\(value)"
  }
}

extension SearchParameters {
  var hitsPerPage: Int? {
    get {
      (parameters[HitsPerPage.key] as? HitsPerPage)?.value
    }
    set {
      parameters[HitsPerPage.key] = newValue.flatMap(HitsPerPage.init)
    }
  }
}

extension HitsPerPage: SettingsParameter {}

extension SettingsParameters {
  /**
   Set the number of hits per page.
   - Engine default: 20
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/hitsPerPage/?language=swift)
   */
  var hitsPerPage: Int? {
    get {
      (parameters[HitsPerPage.key] as? HitsPerPage)?.value
    }
    set {
      parameters[HitsPerPage.key] = newValue.flatMap(HitsPerPage.init)
    }
  }
}
