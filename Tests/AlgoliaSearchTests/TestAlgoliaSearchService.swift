//
//  TestAlgoliaSearchService.swift
//
//
//  Created by Vladislav Fitc on 10.10.2023.
//

import Foundation
import AlgoliaFoundation
import AlgoliaSearchClient
import AlgoliaSearch
import AlgoliaFilters
import XCTest

struct InstantSearchItem: Decodable, Equatable {
  let name: String
}

extension Attribute {
  static let all: Self = Attribute(rawValue: "*".wrappedInQuotes())
}

@MainActor
final class TestAlgoliaSearchService: XCTestCase {

  func testDisjunctiveFacetingIntegrationTest() async throws {
    let client = SearchClient(appID: "latency",
                              apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
    let service = AlgoliaSearchService<InstantSearchItem>(client: client)
    var parameters = SearchParameters()
    parameters.query = ""
    parameters.facets = [.all]
    parameters.attributesToRetrieve = ["\"name\"", "\"brand\""]
    parameters.attributesToHighlight = []
    parameters.attributesToSnippet = []
    let filterGroups = [
      OrFilterGroup(filters: [FacetFilter(attribute: "brand", value: "Yamaha")])
    ]
    let request = AlgoliaSearchRequest(indexName: "instant_search",
                                       searchParameters: parameters,
                                       filterGroups: filterGroups)
    let response = try await service.fetchResponse(for: request)
    for (key, values) in response.searchResponse.facets {
      print(key)
      for value in values {
        print("\t\(value)")
      }
    }
  }

  func testHierarchicalIntegrationTest() async throws {
    let client = SearchClient(appID: "latency",
                              apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
    let service = AlgoliaSearchService<InstantSearchItem>(client: client)
    var parameters = SearchParameters()
    parameters.query = ""
    parameters.facets = [.all]
    parameters.attributesToRetrieve = ["\"name\"", "\"brand\""]
    parameters.attributesToHighlight = []
    parameters.attributesToSnippet = []
    let filterGroups = [
      OrFilterGroup(filters: [FacetFilter(attribute: "brand", value: "Yamaha")])
    ]
    let request = AlgoliaSearchRequest(indexName: "instant_search",
                                       searchParameters: parameters,
                                       filterGroups: filterGroups)
    let response = try await service.fetchResponse(for: request)
    for (key, values) in response.searchResponse.facets {
      print(key)
      for value in values {
        print("\t\(value)")
      }
    }
  }

}
