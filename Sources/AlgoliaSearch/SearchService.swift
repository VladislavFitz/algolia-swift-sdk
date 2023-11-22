//
//  SearchService.swift
//
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

/// `SearchService` is a generic protocol that defines the required interface for a search service,
/// responsible for fetching search responses conforming to the `SearchResponse` protocol.
/// A custom type conforming to this protocol should be able to fetch a response for a given search request
/// that conforms to the `SearchRequest` protocol.
///
/// Usage:
/// ```
/// struct CustomSearchService: SearchService {
///   typealias Request = CustomSearchRequest
///   typealias Response = CustomSearchResponse
///
///   func fetchResponse(for request: CustomSearchRequest) async throws -> CustomSearchResponse { ... }
/// }
/// ```
///
/// - Note: The `Request` and `Response` associated types represent the search request and response types,
///         respectively, which conform to the `SearchRequest` and `SearchResponse` protocols.
public protocol SearchService {
  /// The associated search request type that conforms to the `SearchRequest` protocol.
  associatedtype Request: SearchRequest

  /// The associated search response type that conforms to the `SearchResponse` protocol.
  associatedtype Response: SearchResponse

  /// Fetches a search response for a given search request.
  ///
  /// - Parameter request: The `SearchRequest` for which to fetch the response.
  /// - Returns: A `SearchResponse` containing the data.
  /// - Throws: An error if the fetch operation fails.
  func fetchResponse(for request: Request) async throws -> Response
}
