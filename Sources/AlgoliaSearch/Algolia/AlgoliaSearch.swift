//
//  AlgoliaSearch.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import SwiftUI
import AlgoliaFoundation
import AlgoliaSearchClient
import AlgoliaFilters
import Combine

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
@MainActor
public final class AlgoliaSearch<Hit: Decodable & Equatable>: Search<AlgoliaSearchService<Hit>, AlgoliaPaginationRequestFactory<Hit>> {
    
  @Published public var query: String
  @Published public var indexName: IndexName
  @Published public var filters: AlgoliaFilters.Filters
  
  private var cancellables: Set<AnyCancellable> = []

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
    let request = AlgoliaSearchRequest(indexName: indexName,
                                       searchParameters: .init([Facets(["*"])]),
                                       filterGroups: [])
    let paginationRequestFactory = AlgoliaPaginationRequestFactory<Hit>()
    self.query = ""
    self.indexName = indexName
    self.filters = Filters()
    super.init(service: service,
               request: request,
               factory: paginationRequestFactory)
    setupSubscriptions()
  }
  
  private func setupSubscriptions() {
    filters
      .$groups
      .removeDuplicates(by: { l, r in
        l.values.map(\.rawValue) == r.values.map(\.rawValue)
      })
      .map(\.values)
      .sink { [weak self]  groups in
        self?.request.filterGroups = Array(groups)
        self?.objectWillChange.send()
      }.store(in: &cancellables)
    
    $query
      .removeDuplicates()
      .sink { [weak self] query in
        self?.request.searchParameters.query = query
      }
      .store(in: &cancellables)
    $indexName
      .removeDuplicates()
      .sink { [weak self] indexName in
        self?.request.indexName = indexName
      }
      .store(in: &cancellables)
  }
  
  func fetchLatestHits() -> [Hit] {
    guard let latestResponse else {
      return []
    }
    let hits = try? latestResponse.fetchHits() as [Hit]
    return hits ?? []
  }
  
}
