import AlgoliaFoundation
@testable import AlgoliaInsightsClient
import AlgoliaSearchClient
import Foundation
import TestHelper
import XCTest

class IndexingIntegrationTests: XCTestCase {
  func testInsights() async throws {
    let credentials = Credentials.primary

    let index = SearchClient(appID: credentials.applicationID, apiKey: credentials.apiKey).index(withName: "\(String.uniquePrefix)_\(name)")

    let insightsClient = InsightsClient(appID: credentials.applicationID, apiKey: credentials.apiKey)

    let records: [JSON] = [
      ["objectID": "one"],
      ["objectID": "two"]
    ]

    try await index.saveObjects(records).wait()

    let timestamp = Date().addingTimeInterval(-.days(2))
    let event = try Event.click(name: "foo", indexName: index.name, userToken: "bar", timestamp: timestamp, objectIDs: ["one", "two"])
    try await insightsClient.send(event)

    let events: [Event] = [
      try .click(name: "foo", indexName: index.name, userToken: "bar", timestamp: timestamp, objectIDs: ["one", "two"]),
      try .click(name: "foo", indexName: index.name, userToken: "bar", timestamp: timestamp, objectIDs: ["one", "two"])
    ]
    try await insightsClient.send(events)

    let searchParameters = SearchParameters(ClickAnalytics(true))
    let queryID = try await index.search(parameters: searchParameters).queryID
    XCTAssertNotNil(queryID)

    let eventsAfterSearch = [
      try Event.view(name: "foo", indexName: index.name, userToken: "bar", filters: ["filter:foo", "filter:bar"]),
      try Event.view(name: "foo", indexName: index.name, userToken: "bar", objectIDs: ["one", "two"]),
      try Event.click(name: "foo", indexName: index.name, userToken: "bar", queryID: queryID!, objectIDsWithPositions: [("one", 1), ("two", 2)]),
      try Event.click(name: "foo", indexName: index.name, userToken: "bar", filters: ["filter:foo", "filter:bar"]),
      try Event.click(name: "foo", indexName: index.name, userToken: "bar", objectIDs: ["one", "two"]),
      try Event.conversion(name: "foo", indexName: index.name, userToken: "bar", queryID: nil, objectIDs: ["one", "two"]),
      try Event.conversion(name: "foo", indexName: index.name, userToken: "bar", queryID: nil, filters: ["filter:foo", "filter:bar"]),
      try Event.conversion(name: "foo", indexName: index.name, userToken: "bar", queryID: queryID!, objectIDs: ["one", "two"]),
      try Event.conversion(name: "foo", indexName: index.name, userToken: "bar", queryID: queryID!, filters: ["filter:foo", "filter:bar"])
    ]

    try await insightsClient.send(eventsAfterSearch)
  }
}
