//
//  AlgoliaSearchRequest.swift
//  
//
//  Created by Vladislav Fitc on 22.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation
import AlgoliaFilters

/// `AlgoliaSearchRequest` is a concrete implementation of the `SearchRequest` protocol, specifically tailored for Algolia search engine.
/// It represents a search request for Algolia with an index name and search parameters.
///
/// Usage:
/// ```
/// let request = AlgoliaSearchRequest<CustomDecodableItem>(indexName: "your_index_name",
///                                                          searchParameters: SearchParameters([]))
/// ```
///
/// - Note: The `Hit` type parameter represents the type of the items in the search results and should conform to the `Decodable` protocol.
public struct AlgoliaSearchRequest: SearchRequest {

  public static func == (lhs: AlgoliaSearchRequest, rhs: AlgoliaSearchRequest) -> Bool {
    lhs.indexName == rhs.indexName && lhs.searchParameters == rhs.searchParameters
  }

  /// The name of the index to perform search requests on.
  public var indexName: IndexName

  /// The search parameters for the Algolia search request.
  public var searchParameters: SearchParameters

  public var filterGroups: [FilterGroup]

  /// Initializes a new `AlgoliaSearchRequest` object with the provided index name and search parameters.
  ///
  /// - Parameters:
  ///   - indexName: The name of the index to perform search requests on.
  ///   - searchParameters: The search parameters for the Algolia search request.
  public init(indexName: IndexName,
              searchParameters: SearchParameters = .init([]),
              filterGroups: [FilterGroup] = []) {
    self.indexName = indexName
    self.searchParameters = searchParameters
    self.filterGroups = filterGroups
  }

}
