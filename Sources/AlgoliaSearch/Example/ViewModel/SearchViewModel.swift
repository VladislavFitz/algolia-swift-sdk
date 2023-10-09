//
//  SearchViewModel.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import AlgoliaFoundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
  
  @Published var searchQuery: String = "" {
    didSet {
      notifyQueryChanged()
    }
  }
    
  @Published var suggestions: [QuerySuggestion]
  
  var hits: PaginatedDataViewModel<AlgoliaHitsPage<InstantSearchHit>> {
    search.hits
  }
  
  private var search: AlgoliaSearch<InstantSearchHit>
    
  private var suggestionsSearch: AlgoliaSearch<QuerySuggestion>
        
  private var didSubmitSuggestion: Bool
  
  private var subscriptions: Set<AnyCancellable>
  
  init() {
    let applicationID: ApplicationID = "latency"
    let apiKey: APIKey = "1f6fd3a6fb973cb08419fe7d288fa4db"
    let search = AlgoliaSearch<InstantSearchHit>(applicationID: applicationID,
                                                 apiKey: apiKey,
                                                 indexName: "instant_search")
    let suggestionsSearch = AlgoliaSearch<QuerySuggestion>(applicationID: applicationID,
                                                           apiKey: apiKey,
                                                           indexName: "query_suggestions")
    self.search = search
    self.suggestionsSearch = suggestionsSearch
    
    didSubmitSuggestion = false
    suggestions = []
    subscriptions = []
    
    suggestionsSearch
      .$latestResponse
      .sink { [weak self]  response in
        self?.suggestions = (try? response?.fetchHits()) ?? []
      }
      .store(in: &subscriptions)
      
    Task {
      _ = try await suggestionsSearch.fetchInitialPage()
    }
  }
  
  func completeSuggestion(_ suggestion: String) {
    searchQuery = suggestion
  }
    
  func submitSuggestion(_ suggestion: String) {
    didSubmitSuggestion = true
    searchQuery = suggestion
  }
    
  func submitSearch() {
    suggestions = []
    search.request.searchParameters.query = searchQuery
  }
  
  private func notifyQueryChanged() {
    if didSubmitSuggestion {
      didSubmitSuggestion = false
      submitSearch()
    } else {
      suggestionsSearch.request.searchParameters.query = searchQuery
      search.request.searchParameters.query = searchQuery
    }
  }
  
  deinit {
    subscriptions.forEach { $0.cancel() }
  }
  
}
