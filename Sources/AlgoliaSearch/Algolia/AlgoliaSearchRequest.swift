//
//  AlgoliaSearchRequest.swift
//  
//
//  Created by Vladislav Fitc on 22.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation

/// `AlgoliaSearchRequest` is a concrete implementation of the `SearchRequest` protocol, specifically tailored for Algolia search engine.
/// It represents a search request for Algolia with an index name and search parameters.
///
/// This struct requires the `Hit` type to conform to the `Decodable` protocol.
///
/// Usage:
/// ```
/// let request = AlgoliaSearchRequest<CustomDecodableItem>(indexName: "your_index_name",
///                                                          searchParameters: SearchParameters([]))
/// ```
///
/// - Note: The `Hit` type parameter represents the type of the items in the search results and should conform to the `Decodable` protocol.
public struct AlgoliaSearchRequest: SearchRequest {
  
  /// The name of the index to perform search requests on.
  public var indexName: IndexName
  
  /// The search parameters for the Algolia search request.
  public var searchParameters: SearchParameters
  
  /// Initializes a new `AlgoliaSearchRequest` object with the provided index name and search parameters.
  ///
  /// - Parameters:
  ///   - indexName: The name of the index to perform search requests on.
  ///   - searchParameters: The search parameters for the Algolia search request.
  init(indexName: IndexName,
       searchParameters: SearchParameters = .init([])) {
    self.indexName = indexName
    self.searchParameters = searchParameters
    self.searchParameters.query = ""
  }
      
}
