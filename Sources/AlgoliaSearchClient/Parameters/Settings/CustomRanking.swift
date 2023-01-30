import AlgoliaFoundation
import Foundation
/**
 Specifies the [CustomRankingCriterion].
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/customRanking/?language=swift)
 */
public struct CustomRanking: ValueRepresentable, SettingsParameter {
  static let key = "customRanking"
  public var key: String { Self.key }
  public let value: [CustomRankingCriterion]

  public init(_ value: [CustomRankingCriterion]) {
    self.value = value
  }
}

public extension SettingsParameters {
  /**
   Specifies the [CustomRankingCriterion].
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/customRanking/?language=swift)
   */
  var customRanking: [CustomRankingCriterion]? {
    get {
      (parameters[CustomRanking.key] as? CustomRanking)?.value
    }
    set {
      parameters[CustomRanking.key] = newValue.flatMap(CustomRanking.init)
    }
  }
}
