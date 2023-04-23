//
//  AlgoliaSearch.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaFoundation
import AlgoliaSearchClient

/// `AlgoliaSearch` is a subclass of the `Search` class, specifically tailored to work with the Algolia search engine.
/// It uses the `AlgoliaSearchService` to perform search requests.
///
/// This class requires the `Hit` type to conform to the `Decodable` protocol.
///
/// Usage:
/// ```
/// struct CustomDecodableItem: Decodable {
///   // Your custom decodable properties and methods
/// }
///
/// let algoliaSearch = AlgoliaSearch<CustomDecodableItem>(applicationID: "your_app_id",
///                                                         apiKey: "your_api_key",
///                                                         indexName: "your_index_name")
/// ```
///
/// - Note: The `Hit` type parameter represents the type of the items in the search results and should conform to the `Decodable` protocol.
public final class AlgoliaSearch<Hit: Decodable>: Search<AlgoliaSearchService<Hit>> {
  
  /// Initializes a new `AlgoliaSearch` object with the provided application ID, API key, and index name.
  ///
  /// - Parameters:
  ///   - applicationID: The Application ID of your Algolia account.
  ///   - apiKey: The API key for your Algolia account.
  ///   - indexName: The name of the index to perform search requests on.
  public init(applicationID: ApplicationID,
              apiKey: APIKey,
              indexName: IndexName) {
    let client = SearchClient(appID: applicationID,
                              apiKey: apiKey)
    let service = AlgoliaSearchService<Hit>(client: client)
    let request = AlgoliaSearchRequest<Hit>(indexName: indexName,
                                            searchParameters: SearchParameters([]))
    super.init(service: service, request: request)
  }
  
}
