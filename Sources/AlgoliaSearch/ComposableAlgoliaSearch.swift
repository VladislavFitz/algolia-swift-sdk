//
//  ComposableSearch.swift
//
//
//  Created by Vladislav Fitc on 05.10.2023.
//

import Foundation
import ComposableArchitecture
import AlgoliaSearchClient
import AlgoliaFoundation
import Logging

struct ComposableAlgoliaSearch<Service: SearchService, Hit: Decodable & Equatable>: Reducer where Service.Request == AlgoliaSearchRequest<Hit>, Service.Response == AlgoliaSearchResponse<Hit> {
  
  var service: Service
  let logger: Logger
  
  init(service: Service) {
    self.service = service
    self.logger = Logger(label: "ComposableSearch")
  }
  
  struct State: Equatable {
    var indexName: IndexName
    var searchParameters: SearchParameters
    var items: [Hit]
    
    init(indexName: IndexName,
         searchParameters: SearchParameters = .init([]),
         items: [Hit] = []) {
      self.indexName = indexName
      self.searchParameters = searchParameters
      self.items = items
    }
  }
  
  enum Action: Equatable {
    case searchQueryChanged(String)
    case indexNameChanged(IndexName)
    case filtersChanged(String)
    case pageChanged(Int)
    case receivedSearchResult(TaskResult<[Hit]>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .searchQueryChanged(let query):
      state.searchParameters.query = query
      state.items.removeAll()
      let (indexName, parameters) = (state.indexName, state.searchParameters)
      return .run { send in
        await send(.receivedSearchResult(TaskResult { try await self.service.fetchResponse(for: .init(indexName: indexName, searchParameters: parameters)).fetchPage().items }))
      }
      
    case .filtersChanged(let filters):
      state.searchParameters.filters = filters
      state.items.removeAll()
      let (indexName, parameters) = (state.indexName, state.searchParameters)
      return .run { send in
        await send(.receivedSearchResult(TaskResult { try await self.service.fetchResponse(for: .init(indexName: indexName, searchParameters: parameters)).fetchPage().items }))
      }
      
    case .indexNameChanged(let indexName):
      state.indexName = indexName
      state.items.removeAll()
      let (indexName, parameters) = (state.indexName, state.searchParameters)
      return .run { send in
        await send(.receivedSearchResult(TaskResult { try await self.service.fetchResponse(for: .init(indexName: indexName, searchParameters: parameters)).fetchPage().items }))
      }
      
    case .pageChanged(let page):
      state.searchParameters.page = page
      let (indexName, parameters) = (state.indexName, state.searchParameters)
      return .run { send in
        await send(.receivedSearchResult(TaskResult { try await self.service.fetchResponse(for: .init(indexName: indexName, searchParameters: parameters)).fetchPage().items }))
      }
      
    case .receivedSearchResult(let response):
      switch response {
      case .success(let hits):
        state.items.append(contentsOf: hits)
      case .failure(let error):
        logger.error("Search response error: \(error.localizedDescription)")
      }
      return .none
    }
  }
  
}
