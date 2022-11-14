import Foundation
/**
 Specifies the [CustomRankingCriterion].
 - Engine default: []
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/customRanking/?language=swift)
 */
struct CustomRanking: SettingsParameter {
  static let key = "customRanking"
  var key: String { Self.key }
  let value: [CustomRankingCriterion]

  init(_ value: [CustomRankingCriterion]) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension SettingsParameters {
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
