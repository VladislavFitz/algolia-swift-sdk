import Foundation

public extension SearchClient {
  /**
   Get a list of indices with their associated metadata.

   This method retrieves a list of all indices associated with a given ApplicationID.
   The returned list includes the name of the index as well as its associated metadata,
   such as the number of records, size, last build time, and pending tasks.

   - Returns: IndicesListResponse  object
   */
  func listIndices() async throws -> IndicesListResponse {
    let responseData = try await transport.perform(method: .get,
                                                   path: "/1/indexes",
                                                   headers: [:],
                                                   body: nil,
                                                   requestType: .read)
    return try jsonDecoder.decode(IndicesListResponse.self, from: responseData)
  }
}
