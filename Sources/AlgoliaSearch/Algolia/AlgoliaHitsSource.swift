//
//  QueryHitsSource.swift
//  
//
//  Created by Vladislav Fitc on 07.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation

public class AlgoliaHitsSource: PageSource {
  public typealias Item = AlgoliaHitsPage.Item
  public typealias Page = AlgoliaHitsPage
  
    
  public let client: SearchClient
  public let query: IndexedQuery
      
  public init(client: SearchClient,
              query: IndexedQuery) {
    self.client = client
    self.query = query
  }
  
  public func fetchInitialPage() async throws -> AlgoliaHitsPage {
    AlgoliaHitsPage(page: 0, hits: [], hasPrevious: false, hasNext: false)
  }
  
  public func fetchPage(before page: AlgoliaHitsPage) async throws -> AlgoliaHitsPage {
    AlgoliaHitsPage(page: 0, hits: [], hasPrevious: false, hasNext: false)
  }
  
  public func fetchPage(after page: AlgoliaHitsPage) async throws -> AlgoliaHitsPage {
    AlgoliaHitsPage(page: 0, hits: [], hasPrevious: false, hasNext: false)
  }
  
}
