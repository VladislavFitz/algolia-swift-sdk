//
//  Index+Search.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public extension Index {
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
