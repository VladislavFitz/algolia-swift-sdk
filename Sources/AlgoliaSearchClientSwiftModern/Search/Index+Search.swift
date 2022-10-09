//
//  Index+Search.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public extension Index {
  /**
   Method used for querying an index.

   - Note: The search query only allows for the retrieval of up to 1000 hits.
   If you need to retrieve more than 1000 hits (e.g. for SEO), you can either leverage
   the [Browse index](https://www.algolia.com/doc/api-reference/api-methods/browse/) method or increase
   the [paginationLimitedTo](https://www.algolia.com/doc/api-reference/api-parameters/paginationLimitedTo/) parameter.
   - Parameter parameters: search parameters to apply.
   - Returns: SearchResponse structure
   */
  func search(parameters: SearchParameters) async throws -> SearchResponse {
    let body = try client.jsonEncoder.encode(parameters)
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/\(indexName.rawValue)/query",
                                                          headers: ["Content-Type": "application/json"],
                                                          body: body,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(SearchResponse.self, from: responseData)
  }
}
