//
//  AlgoliaSearchRequest.swift
//  
//
//  Created by Vladislav Fitc on 22.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation

public struct AlgoliaSearchRequest {
  
  public var indexName: IndexName
  public var searchParameters: SearchParameters
  
  init(indexName: IndexName,
       searchParameters: SearchParameters) {
    self.indexName = indexName
    self.searchParameters = searchParameters
  }
  
  func diff(_ request: Self) -> Bool {
    request.searchParameters.query != searchParameters.query ||
    request.searchParameters.filters != searchParameters.filters ||
    request.indexName != indexName
  }
  
}
