import AlgoliaFoundation
import Foundation

struct MultipleQueriesRequest {
  let requests: [Either<IndexedQuery, IndexedFacetQuery>]
  let strategy: MultipleQueriesStrategy
}

extension MultipleQueriesRequest: Encodable {
  enum CodingKeys: String, CodingKey {
    case requests
    case strategy
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(requests, forKey: .requests)
    try container.encodeIfPresent(strategy, forKey: .strategy)
  }
}
