//
//  Client+Search.swift
//
//
//  Created by Vladislav Fitc on 09.08.2022.
//

import Foundation

public extension Client {
  func index(withName indexName: IndexName) -> Index {
    return Index(indexName: indexName, client: self)
  }
}

public typealias MultiSearchQuery = Either<IndexedQuery, IndexedFacetQuery>

public extension Client {
  func search(queries: [MultiSearchQuery],
              strategy: MultipleQueriesStrategy = .none) async throws -> MultiSearchResponse {
    let request = MultipleQueriesRequest(requests: queries, strategy: strategy)
    let body = try jsonEncoder.encode(request)
    let responseData = try await transport.perform(method: .post,
                                                   path: "/1/indexes/*/queries",
                                                   headers: ["Content-Type": "application/json"],
                                                   body: body,
                                                   requestType: .read)
    return try jsonDecoder.decode(MultiSearchResponse.self, from: responseData)
  }
}
