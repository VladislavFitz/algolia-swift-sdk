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
    
  private func generateRequests(_ request: AlgoliaSearchRequest) -> [IndexedQuery] {
    var parameters = request.searchParameters
    parameters.filters = RawFilterTransformer.transform(request.filterGroups)
    
    func indexed(_ parameters: SearchParameters) -> IndexedQuery {
      IndexedQuery(indexName: request.indexName,
                   searchParameters: parameters)
    }
    
    var queries: [IndexedQuery] = []
    
    queries.append(indexed(parameters))
    
    let disjunctiveQueries = request
      .filterGroups
      .extractDisjunctiveAttributes()
      .map { facet in
        var searchParameters = parameters
        searchParameters.onlyFacets()
        searchParameters.facets = [Attribute(rawValue: facet.rawValue.wrappedInQuotes())]
        searchParameters.filters = request.filterGroups.removingFilters(for: facet)
        return searchParameters
      }
      .map(indexed)
    queries.append(contentsOf: disjunctiveQueries)
    
    if let appliedFilter = request.hierarchicalInput.filters.last {
      let hierarchicalFilters: [FacetFilter?] = [.none] + request.hierarchicalInput.filters
      let hierachicalQueries = zip(request.hierarchicalInput.attributes, hierarchicalFilters)
        .map { (attribute, hierarchicalFilter) in
          var searchParameters = parameters
          searchParameters.onlyFacets()
          searchParameters.facets = [attribute]
          searchParameters.filters = request.filterGroups.removing(appliedFilter, appending: hierarchicalFilter)
          return searchParameters
        }
        .map(indexed)
      queries.append(contentsOf: hierachicalQueries)
    }
    
    return queries
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

fileprivate extension Array<FilterGroup> {
  
  func extractDisjunctiveAttributes() -> Set<Attribute> {
    let attributesList = flatMap { group in
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
  
  func removingFilters(for attribute: Attribute) -> String {
    let groups = map { group in
      guard let orGroup = group as? OrFilterGroup<FacetFilter> else {
        return group
      }
      return OrFilterGroup(filters: orGroup.typedFilters.filter { $0.attribute != attribute })
    }
    return RawFilterTransformer.transform(groups)
  }
  
  func removing(_ filter: FacetFilter, appending hierarchicalFilter: FacetFilter?) -> String {
    var groups = map { group in
      guard let andGroup = group as? AndFilterGroup else {
        return group
      }
      let filters = andGroup.filters.filter { ($0 as? FacetFilter) != filter }
      return AndFilterGroup(filters: filters)
    }
    if let hierarchicalFilter {
      groups.append(AndFilterGroup(filters: [hierarchicalFilter]))
    }
    return RawFilterTransformer.transform(groups)
  }

  
}

fileprivate extension SearchParameters {
  
  /// Setup search parameters to fetch only facets information to reduce payload size
  mutating func onlyFacets() {
    attributesToRetrieve = []
    attributesToHighlight = []
    hitsPerPage = 0
    analytics = false
  }
  
}
