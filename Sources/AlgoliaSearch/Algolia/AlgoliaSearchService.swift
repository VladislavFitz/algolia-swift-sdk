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
    let queries = generateRequests(request)
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
    var parameters = request.searchParameters
    parameters.filters = RawFilterTransformer.transform(request.filterGroups)
    let initialRequest = IndexedQuery(indexName: request.indexName,
                                      searchParameters: parameters)
    
    let disjunctiveRequests = extractDisjunctiveAttributes(request.filterGroups)
      .map { facet in
//        var request = request
        var searchParameters = parameters
        searchParameters.facets = [Attribute(rawValue: facet.rawValue.wrappedInQuotes())]
        searchParameters.filters = removingFilters(for: facet, from: request.filterGroups)
        searchParameters.attributesToRetrieve = []
        searchParameters.attributesToHighlight = []
        searchParameters.hitsPerPage = 0
        searchParameters.analytics = false
//        request.searchParameters = searchParameters
        return IndexedQuery(indexName: request.indexName, searchParameters: request.searchParameters)
      }
    return [initialRequest] + disjunctiveRequests
  }
  
  private func removingFilters(for attribute: Attribute, from groups: [FilterGroup]) -> String {
    let groups = groups.map { group in
      guard let orGroup = group as? OrFilterGroup<FacetFilter> else {
        return group
      }
      return OrFilterGroup(filters: orGroup.typedFilters.filter { $0.attribute != attribute })
    }
    return RawFilterTransformer.transform(groups)
  }
  
  private func merge(_ responses: [AlgoliaSearchClient.SearchResponse]) -> AlgoliaSearchClient.SearchResponse {
    guard var mainResponse = responses.first else {
      fatalError("Empty list of responses to merge")
    }
    for response in responses.dropFirst() {
      for (attribute, values) in response.facets {
        mainResponse.facets[attribute] = values
      }
    }
    return mainResponse
  }
    
}
