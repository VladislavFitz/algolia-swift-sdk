import Foundation

public extension Index {
  /**
   Method used for querying an index.

   - Note: The search query only allows for the retrieval of up to 1000 hits.
   If you need to retrieve more than 1000 hits (e.g. for SEO), you can either leverage
   the [Browse index](https://www.algolia.com/doc/api-reference/api-methods/browse/) method or increase
   the [paginationLimitedTo](https://www.algolia.com/doc/api-reference/api-parameters/paginationLimitedTo/) parameter.
   - Parameter parameters: search parameters to apply to the search
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

  /**
   Get all index content without any record limit. Can be used for backups.

   - Note: The browse method is an alternative to the Search index method.
   If you need to retrieve the full content of your index (for backup, SEO purposes or for running a script on it),
   you should use this method instead.
   Results are ranked by attributes and custom ranking.
   But for performance reasons, there is no ranking based on:
   - distinct
   - typo-tolerance
   - number of matched words
   - proximity
   - geo distance

   You shouldn’t use this method for building a search UI.
   The analytics API does not collect data from browse method usage.
   If you need to retrieve more than 1,000 results, you should look into the
   [paginationLimitedTo](https://www.algolia.com/doc/api-reference/api-parameters/paginationLimitedTo/) parameter.

   If more records are available, SearchResponse.cursor will not be null.

   - Parameter parameters: search parameters to apply to the search.
   - Returns: SearchResponse object
   */
  func browse(parameters: SearchParameters = SearchParameters([])) async throws -> SearchResponse {
    let body = try client.jsonEncoder.encode(parameters)
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/\(indexName.rawValue)/browse",
                                                          headers: [:],
                                                          body: body,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(SearchResponse.self, from: responseData)
  }

  /**
   Get all index content without any record limit. Can be used for backups.

   - Note: The browse method is an alternative to the Search index method.
   If you need to retrieve the full content of your index (for backup, SEO purposes or for running a script on it),
   you should use this method instead.
   Results are ranked by attributes and custom ranking.
   But for performance reasons, there is no ranking based on:
   - distinct
   - typo-tolerance
   - number of matched words
   - proximity
   - geo distance

   You shouldn’t use this method for building a search UI.
   The analytics API does not collect data from browse method usage.
   If you need to retrieve more than 1,000 results, you should look into the
   [paginationLimitedTo](https://www.algolia.com/doc/api-reference/api-parameters/paginationLimitedTo/) parameter.

   If more records are available, SearchResponse.cursor will not be null.

   - Parameter cursor: Cursor indicating the location to resume browsing from.
   Must match the value returned by the previous call to browse SearchResponse.cursor.
   - Parameter requestOptions: Configure request locally with RequestOptions.
   - Returns: SearchResponse object
   */
  func browse(cursor: Cursor) async throws -> SearchResponse {
    let body = try client.jsonEncoder.encode(FieldWrapper.cursor(cursor))
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/\(indexName.rawValue)/browse",
                                                          headers: [:],
                                                          body: body,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(SearchResponse.self, from: responseData)
  }
}
