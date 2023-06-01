//
//  SearchViewModel.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import SwiftUI
import Combine

protocol SuggestionViewModel: ObservableObject {
  
  var suggestions: [QuerySuggestion] { get }
  
  func completeSuggestion(_ suggestion: String)
  func submitSuggestion(_ suggestion: String)
  
}

@available(iOS 14.0, *)
final class SearchViewModel: SuggestionViewModel {
  
  @Published var search: AlgoliaSearch<InstantSearchHit>
    
  @Published var suggestionsSearch: AlgoliaSearch<QuerySuggestion>
  
  @Published var searchQuery: String = "" {
    didSet {
      notifyQueryChanged()
    }
  }
  
  @Published var isDisplayingSuggestions: Bool
  
  @Published var suggestions: [QuerySuggestion]
        
  private var didSubmitSuggestion: Bool
  
  var subscription: AnyCancellable?
  
  init() {
    search = AlgoliaSearch<InstantSearchHit>(applicationID: "latency",
                                             apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                             indexName: "instant_search")
    let suggestionsSearch = AlgoliaSearch<QuerySuggestion>(applicationID: "latency",
                                                           apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                                           indexName: "query_suggestions")
    self.suggestionsSearch = suggestionsSearch
    didSubmitSuggestion = false
    isDisplayingSuggestions = true
    suggestions = []
    subscription = suggestionsSearch.$latestResponse.sink { [weak self]  response in
      self?.suggestions = (try? response?.fetchHits()) ?? []
    }
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
    subscription?.cancel()
  }
  
}
