import Foundation
/**
 Controls the way results are sorted.
 - Engine default: [.typo, .geo, .words, .filters, .proximity, .attribute, .exact, .custom]
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/ranking/?language=swift)
 */
struct Ranking: SettingsParameter {
  static let key = "customRanking"
  var key: String { Self.key }
  let value: [RankingCriterion]

  init(_ value: [RankingCriterion]) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension SettingsParameters {
  /**
   Controls the way results are sorted.
   - Engine default: [.typo, .geo, .words, .filters, .proximity, .attribute, .exact, .custom]
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/ranking/?language=swift)
   */
  var ranking: [RankingCriterion]? {
    get {
      (parameters[Ranking.key] as? Ranking)?.value
    }
    set {
      parameters[Ranking.key] = newValue.flatMap(Ranking.init)
    }
  }
}
