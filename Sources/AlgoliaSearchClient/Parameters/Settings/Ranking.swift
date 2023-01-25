import AlgoliaFoundation
import Foundation
/**
 Controls the way results are sorted.
 - Engine default: [.typo, .geo, .words, .filters, .proximity, .attribute, .exact, .custom]
 - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/ranking/?language=swift)
 */
public struct Ranking: ValueRepresentable, SettingsParameter {
  static let key = "customRanking"
  public var key: String { Self.key }
  public let value: [RankingCriterion]

  public init(_ value: [RankingCriterion]) {
    self.value = value
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
