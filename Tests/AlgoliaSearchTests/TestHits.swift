import AlgoliaFoundation
import AlgoliaSearchClient
@testable import AlgoliaSearch
import TestHelper
import XCTest

final class HitsTests: XCTestCase {
  
  func testHits() async throws {
    let client = SearchClient(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
    let source = AlgoliaHitsSource(client: client, query: .init(indexName: "bestbuy", searchParameters: SearchParameters()))
    let hits = Hits(source: source)
//    let firstHit = try await hits.hit(atIndex: 0)
//    print(firstHit)
//    let twentyFirstHit = try await hits.hit(atIndex: 20)
//    print(twentyFirstHit)
//    let fourtyFirstHit = try await hits.hit(atIndex: 40)
//    print(fourtyFirstHit)
//    let lastHit = try await hits.hit(atIndex: 999)
//    print(lastHit)
  }
  
}
