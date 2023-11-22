//
//  File.swift
//
//
//  Created by Vladislav Fitc on 05.10.2023.
//

@testable import AlgoliaSearch
import ComposableArchitecture
import Foundation
import XCTest

@MainActor
final class ComposableSearchTests: XCTestCase {
  struct Item: Decodable & Equatable {
    let name: String
    let brand: String?
    let price: Price?
    let images: Images

    struct Price: Decodable & Equatable {
      let number: Float
      let displayType: String
    }

    struct Images: Decodable & Equatable {
      let large: URL?
      let small: URL?
    }
  }

//  func testSearch() async {
//    let store = TestStore(initialState: ComposableAlgoliaSearch<AlgoliaSearchService, Item>.State(indexName: "p-development-US__products___")) {
//      ComposableAlgoliaSearch<AlgoliaSearchService, Item>(service: AlgoliaSearchService(client: .init(appID: "0ZV04HYYVJ", apiKey: "f220c49aa52fca828fe5265965a0cab3")))
//    }
//
//    await store.send(.searchQueryChanged("dog food")) { a in
//      a.searchParameters.query = "dog food"
//    }
//    await store.receive(.receivedSearchResult(.success([])))
//  }
}
