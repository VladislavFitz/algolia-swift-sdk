//
//  Search+Algolia.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaFoundation
import AlgoliaSearchClient

extension Search where Service == AlgoliaSearchService {
  
  public convenience init(applicationID: ApplicationID,
                          apiKey: APIKey,
                          indexName: IndexName) {
    let client = SearchClient(appID: applicationID,
                              apiKey: apiKey)
    let service = AlgoliaSearchService(client: client)
    let state = AlgoliaSearchRequest(indexName: indexName,
                      searchParameters: SearchParameters([]))
    self.init(service: service,
              request: state)
  }

}
