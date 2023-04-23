//
//  AlgoliaSearchRequest.swift
//  
//
//  Created by Vladislav Fitc on 22.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation

public struct AlgoliaSearchRequest: SearchRequest {
  
  public var indexName: IndexName
  public var searchParameters: SearchParameters
  
  init(indexName: IndexName,
       searchParameters: SearchParameters) {
    self.indexName = indexName
    self.searchParameters = searchParameters
    self.searchParameters.query = ""
  }
  
  public func isDifferent(to request: Self) -> Bool {
    request.searchParameters.query != searchParameters.query ||
    request.searchParameters.filters != searchParameters.filters ||
    request.indexName != indexName
  }
  
  public func forInitialPage() -> Self {
    var request = self
    request.searchParameters.page = 0
    return request
  }
  
  public func forPage(after page: AlgoliaHitsPage) -> Self {
    var request = self
    request.searchParameters.page = page.page + 1
    return request
  }
  
  public func forPage(before page: AlgoliaHitsPage) -> Self {
    var request = self
    request.searchParameters.page = page.page - 1
    return request
  }
    
}

public class AlgoliaSearchService: SearchService {
    
  public typealias Request = AlgoliaSearchRequest
  public typealias Response = AlgoliaSearchClient.SearchResponse
  
  public let client: SearchClient
  
  public init(client: SearchClient) {
    self.client = client
  }
  
  public func fetchResponse(for request: Request) async throws -> Response {
    try await client
      .index(withName: request.indexName)
      .search(parameters: request.searchParameters)
  }
    
}
