import Foundation

public extension Client {
  func index(withName indexName: IndexName) -> Index {
    return Index(indexName: indexName, client: self)
  }
}

public extension Client {
  /**
   Perform a search for hits or facet values on several indices at the same time, with one method call.

   - Parameter queries: The list of either IndexedQuery or IndexedFacetQuery.
   - Parameter strategy: The MultipleQueriesStrategy to apply (default .none).
   - Returns: The list of either SearchResponse or FacetSearchResponse
   */
  func search(queries: [Either<IndexedQuery, IndexedFacetQuery>],
              strategy: MultipleQueriesStrategy = .none) async throws -> [Either<SearchResponse, FacetSearchResponse>] {
    let request = MultipleQueriesRequest(requests: queries, strategy: strategy)
    let body = try jsonEncoder.encode(request)
    let responseData = try await transport.perform(method: .post,
                                                   path: "/1/indexes/*/queries",
                                                   headers: ["Content-Type": "application/json"],
                                                   body: body,
                                                   requestType: .read)
    return try jsonDecoder.decode(MultiSearchResponse.self, from: responseData).results
  }
}
