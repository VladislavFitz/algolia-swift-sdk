//
//  AlgoliaSearchService.swift
//
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import AlgoliaFilters
import AlgoliaFoundation
import AlgoliaSearchClient
import Foundation
import Logging

public class AlgoliaSearchService<Hit: Decodable & Equatable>: SearchService {
  public let client: SearchClient

  private var logger: Logger

  public init(client: SearchClient) {
    self.client = client
    logger = Logger(label: "algolia search service")
    logger.logLevel = .trace
  }

  public func fetchResponse(for request: AlgoliaSearchRequest) async throws -> AlgoliaSearchResponse<Hit> {
    let components = [
      (title: "index", value: request.indexName.rawValue),
      (title: "query", value: request.searchParameters.query.flatMap { "\"\($0)\"" }),
      (title: "page", value: request.searchParameters.page.flatMap(String.init)),
      (title: "filters", value: request.searchParameters.filters),
    ]
      .filter({ $0.1 != nil })
      .map { "\($0.0): \($0.1!)" }
    logger.trace("request: \(components.joined(separator: ", "))")
    let queries = generateRequests(request)
    let responses = try await client.search(queries: queries.map { .first($0) })
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
    
    let disjunctiveAttributes = request
      .filterGroups
      .extractDisjunctiveAttributes()

    let disjunctiveQueries = disjunctiveAttributes
      .map { facet in
        var searchParameters = parameters
        searchParameters.onlyFacets()
        searchParameters.facets = [Attribute(rawValue: facet.rawValue.wrappedInQuotes())]
        searchParameters.filters = request.filterGroups.removingFilters(for: facet)
        return searchParameters
      }
      .map(indexed)
    queries.append(contentsOf: disjunctiveQueries)
    logger.debug("created \(queries.count) disjunctive queries")

    for hierarchicalGroup in request.filterGroups.compactMap({ $0 as? HierarchicalFilterGroup }) {
      guard let appliedFilter = hierarchicalGroup.hierarchicalFilters.last else {
        continue
      }
      let hierarchicalFilters: [FacetFilter?] = [.none] + hierarchicalGroup.hierarchicalFilters
      let hierachicalQueries = zip(hierarchicalGroup.attributes, hierarchicalFilters)
        .map { attribute, hierarchicalFilter in
          var searchParameters = parameters
          searchParameters.onlyFacets()
          searchParameters.facets = [attribute]
          searchParameters.filters = request.filterGroups.removing(appliedFilter, appending: hierarchicalFilter)
          return searchParameters
        }
        .map(indexed)
      queries.append(contentsOf: hierachicalQueries)
      logger.debug("created \(hierachicalQueries.count) hierarchical queries")
    }

    return queries
  }

  private func merge(_ responses: [AlgoliaSearchClient.SearchResponse]) -> AlgoliaSearchClient.SearchResponse {
    logger.debug("process responses")
    guard var mainResponse = responses.first else {
      fatalError("Empty list of responses to merge")
    }
    for response in responses.dropFirst() {
      logger.debug("received response: \(formattedFacets(response.facets))")
      for (attribute, values) in response.facets {
        mainResponse.facets[attribute] = values
      }
    }
    return mainResponse
  }
}

func formattedFacets(_ facets: [String: [String: Int]]) -> String {
  var output = ""
  for (attribute, values) in facets.sorted(by: { $0.key < $1.key }) {
    output.append("\(attribute):\n")
    for value in values {
      output.append("\t\(value.key) (\(value.value))\n")
    }
  }
  return output
}

private extension [FilterGroup] {
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

private extension SearchParameters {
  /// Setup search parameters to fetch only facets information to reduce payload size
  mutating func onlyFacets() {
    attributesToRetrieve = []
    attributesToHighlight = []
    hitsPerPage = 0
    analytics = false
  }
}
