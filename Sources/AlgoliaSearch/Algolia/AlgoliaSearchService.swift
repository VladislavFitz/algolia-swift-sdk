//
//  AlgoliaSearchService.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaSearchClient

public class AlgoliaSearchService<Hit: Decodable>: SearchService {
    
  public typealias Request = AlgoliaSearchRequest<Hit>
  public typealias Response = AlgoliaSearchResponse<Hit>
  
  public let client: SearchClient
  
  public init(client: SearchClient) {
    self.client = client
  }
  
  public func fetchResponse(for request: Request) async throws -> Response {
    AlgoliaSearchResponse(searchResponse: try await client
      .index(withName: request.indexName)
      .search(parameters: request.searchParameters))
  }
    
}
