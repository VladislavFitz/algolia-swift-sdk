//
//  QueryHitsSource.swift
//  
//
//  Created by Vladislav Fitc on 07.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation

public class AlgoliaHitsSource: HitsSource {
  
  public let client: SearchClient
  public let query: IndexedQuery
      
  public init(client: SearchClient, query: IndexedQuery) {
    self.client = client
    self.query = query
  }
  
  public func fetchHits(forPage pageIndex: Int) async throws -> ([JSON], canLoadMore: Bool) {
    var parameters = query.searchParameters
    parameters.page = pageIndex
    let response = try await client.index(withName: query.indexName).search(parameters: parameters)
    if let nbHits = response.nbHits, let hitsPerPage = response.hitsPerPage, nbHits > 0, hitsPerPage > 0 {
      let latestPageIndex = nbHits / hitsPerPage
      if pageIndex == latestPageIndex {
        return (response.hits, false)
      }
    }
    return (response.hits, true)
  }
  
}
