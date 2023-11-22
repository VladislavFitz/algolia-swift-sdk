//
//  AlgoliaPaginationRequestFactory.swift
//
//
//  Created by Vladislav Fitc on 05.10.2023.
//

import Foundation

public struct AlgoliaPaginationRequestFactory<Hit: Decodable>: PaginationRequestFactory {
  public func forInitialPage(from request: AlgoliaSearchRequest) -> AlgoliaSearchRequest {
    var request = request
    request.searchParameters.page = 0
    return request
  }

  public func forPage(from request: AlgoliaSearchRequest, after page: AlgoliaHitsPage<Hit>) -> AlgoliaSearchRequest {
    var request = request
    request.searchParameters.page = page.page + 1
    return request
  }

  public func forPage(from request: AlgoliaSearchRequest, before page: AlgoliaHitsPage<Hit>) -> AlgoliaSearchRequest {
    var request = request
    request.searchParameters.page = page.page - 1
    return request
  }
}
