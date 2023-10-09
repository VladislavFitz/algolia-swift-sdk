//
//  AlgoliaSearchService.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaFoundation
import AlgoliaSearchClient
import Logging
import AlgoliaFilters

public class AlgoliaSearchService<Hit: Decodable & Equatable>: SearchService {

  public let client: SearchClient
  
  private var logger: Logger
  
  public init(client: SearchClient) {
    self.client = client
    self.logger = Logger(label: "algolia search service")
    self.logger.logLevel = .trace
  }
  
  public func fetchResponse(for request: AlgoliaSearchRequest) async throws -> AlgoliaSearchResponse<Hit> {
    logger.trace("request: index \(request.indexName), query: \"\(request.searchParameters.query ?? "")\" , page: \(request.searchParameters.page ?? 0), filters: \(request.searchParameters.filters ?? "")")
    
    let queries: [IndexedQuery] = generateRequests(request)
    
    let responses = try await client.search(queries: queries.map {.first($0) })
    
    let response = merge(responses.compactMap(\.first))
    return AlgoliaSearchResponse(searchResponse: response)
  }
  
  func extractDisjunctiveAttributes(_ groups: [FilterGroup]) -> Set<Attribute> {
    let attributesList = groups.flatMap { group in
      switch group {
      case let orGroup as OrFilterGroup<FacetFilter>:
        return orGroup.filters.map(\.attribute)
      case let orGroup as OrFilterGroup<NumericFilter>:
        return orGroup.filters.map(\.attribute)
      case let orGroup as OrFilterGroup<TagFilter>:
        return orGroup.filters.map(\.attribute)
      default:
        return []
      }
    }
    return Set(attributesList)
  }
  
  private func generateRequests(_ request: AlgoliaSearchRequest) -> [IndexedQuery] {
    let disjunctiveFacets = extractDisjunctiveAttributes(request.filterGroups)
    return []
  }
  
  private func merge(_ responses: [AlgoliaSearchClient.SearchResponse]) -> AlgoliaSearchClient.SearchResponse {
    .init()
  }
    
}
