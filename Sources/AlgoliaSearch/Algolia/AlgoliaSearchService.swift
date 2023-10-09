//
//  AlgoliaSearchService.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaSearchClient
import Logging

public class AlgoliaSearchService<Hit: Decodable & Equatable>: SearchService {
    
  public typealias Request = AlgoliaSearchRequest
  public typealias Response = AlgoliaSearchResponse<Hit>
  
  public let client: SearchClient
  
  private var logger: Logger
  
  public init(client: SearchClient) {
    self.client = client
    self.logger = Logger(label: "algolia search service")
    self.logger.logLevel = .trace
  }
  
  public func fetchResponse(for request: Request) async throws -> Response {
    logger.trace("request: index \(request.indexName), query: \"\(request.searchParameters.query ?? "")\" , page: \(request.searchParameters.page ?? 0), filters: \(request.searchParameters.filters ?? "")")
    let response = try await client
      .index(withName: request.indexName)
      .search(parameters: request.searchParameters)
    return AlgoliaSearchResponse(searchResponse: response)
  }
    
}
