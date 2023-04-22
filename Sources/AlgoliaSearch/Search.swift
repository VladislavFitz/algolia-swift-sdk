//
//  Search.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation
import Logging

public final class Search<Hit: Decodable>: ObservableObject {
  
  let client: SearchClient
  public var logger: Logger
  
  @Published public var request: AlgoliaSearchRequest {
    didSet {
      if request.diff(oldValue) {
        Task {
          await hits.reset()
          hits.loadNext()
        }
      }
    }
  }
  
  @Published public var hits: Hits<Hit>!
  @Published public var latestResponse: SearchResponse?
  
  public init(client: SearchClient, state: AlgoliaSearchRequest) {
    self.client = client
    self.request = state
    self.latestResponse = .none
    self.logger = Logger(label: "Algolia Search")
    self.hits = Hits(source: self)
    self.request.searchParameters.query = ""
  }
  
}

extension Search: HitsSource {
  
  @MainActor
  public func fetchHits(forPage page: Int) async throws -> ([Hit], canLoadMore: Bool) {
    logger.trace("search for query: \"\(request.searchParameters.query ?? "")\", page: \(request.searchParameters.page ?? 0)")
    request.searchParameters.page = page
    let response = try await client
      .index(withName: request.indexName)
      .search(parameters: request.searchParameters)
    latestResponse = response
    return (try response.fetchHits(), response.canLoadMore)
  }
  
}

extension Search {
  
  public convenience init(applicationID: ApplicationID,
                          apiKey: APIKey,
                          indexName: IndexName) {
    let client = SearchClient(appID: applicationID,
                              apiKey: apiKey)
    let state = AlgoliaSearchRequest(indexName: indexName,
                      searchParameters: SearchParameters([]))
    self.init(client: client,
              state: state)
  }

}
