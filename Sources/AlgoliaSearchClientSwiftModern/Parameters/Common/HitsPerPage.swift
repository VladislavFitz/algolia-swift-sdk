import Foundation
/**
 Set the number of hits per page.
 - Engine default: 20
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/hitsPerPage/?language=swift)
 */
public struct HitsPerPage: ValueRepresentable {
  static let key = "hitsPerPage"
  public var key: String { HitsPerPage.key }
  public let value: Int

  public init(_ value: Int) {
    self.value = value
  }
}

extension HitsPerPage: SearchParameter {}

public extension SearchParameters {
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

extension HitsPerPage: SettingsParameter {}

public extension SettingsParameters {
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
