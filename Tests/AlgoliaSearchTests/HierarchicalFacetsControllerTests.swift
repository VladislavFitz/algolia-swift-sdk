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

@MainActor
final class TestHierarchicalFacetController: XCTestCase {
  
//  func testDisjunctiveFacetingIntegrationTest() async throws {
//    let client = SearchClient(appID: "latency",
//                              apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
//    let service = AlgoliaSearchService<InstantSearchItem>(client: client)
//    var parameters = SearchParameters()
//    parameters.query = ""
//    parameters.facets = [.all]
//    parameters.attributesToRetrieve = ["\"name\"", "\"brand\""]
//    parameters.attributesToHighlight = []
//    parameters.attributesToSnippet = []
//    let filterGroups = [
//      OrFilterGroup(filters: [FacetFilter(attribute: "brand", value: "Yamaha")])
//    ]
//    let request = AlgoliaSearchRequest(indexName: "instant_search",
//                                       searchParameters: parameters,
//                                       filterGroups: filterGroups)
//    let response = try await service.fetchResponse(for: request)
//    for (key, values) in response.searchResponse.facets {
//      print(key)
//      for value in values {
//        print("\t\(value)")
//      }
//    }
//  }
  
  func testController() {
    let hierarchicalAttributes: [Attribute] = (0...2)
      .map { "hierarchicalCategories.lvl\($0)" }
    
    let clothing = "Clothing"
    let book = "Book"
    let furniture = "Furniture"

    let clothing_men = "Clothing > Men"
    let clothing_women = "Clothing > Women"

    let clothing_men_hats = "Clothing > Men > Hats"
    let clothing_men_shirt = "Clothing > Men > Shirt"
    
    let controller = HierarchicalFacetController(attributes: hierarchicalAttributes,
                                                 separator: " > ")
    
    controller.select(clothing)
    XCTAssertEqual(controller.selections, [clothing])
    XCTAssertEqual(controller.filters, [
      FacetFilter(attribute: "hierarchicalCategories.lvl0", stringValue: clothing)
    ])
    
    controller.select(clothing_men)
    XCTAssertEqual(controller.selections, [clothing, clothing_men])
    XCTAssertEqual(controller.filters, [
      FacetFilter(attribute: "hierarchicalCategories.lvl0", stringValue: clothing),
      FacetFilter(attribute: "hierarchicalCategories.lvl1", stringValue: clothing_men)
    ])
        
    controller.select(clothing_men_shirt)
    XCTAssertEqual(controller.selections, [clothing, clothing_men, clothing_men_shirt])
    XCTAssertEqual(controller.filters, [
      FacetFilter(attribute: "hierarchicalCategories.lvl0", stringValue: clothing),
      FacetFilter(attribute: "hierarchicalCategories.lvl1", stringValue: clothing_men),
      FacetFilter(attribute: "hierarchicalCategories.lvl2", stringValue: clothing_men_shirt)
    ])
    
    controller.select(clothing_men)
    XCTAssertEqual(controller.selections, [clothing, clothing_men])
    XCTAssertEqual(controller.filters, [
      FacetFilter(attribute: "hierarchicalCategories.lvl0", stringValue: clothing),
      FacetFilter(attribute: "hierarchicalCategories.lvl1", stringValue: clothing_men)
    ])

    controller.select(clothing)
    XCTAssertEqual(controller.selections, [clothing])
    XCTAssertEqual(controller.filters, [
      FacetFilter(attribute: "hierarchicalCategories.lvl0", stringValue: clothing)
    ])
    
    controller.select(clothing)
    XCTAssertTrue(controller.selections.isEmpty)
    XCTAssertTrue(controller.filters.isEmpty)

  }
  
}
