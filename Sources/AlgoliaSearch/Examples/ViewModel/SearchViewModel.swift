//
//  SearchViewModel.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
final class SearchViewModel: ObservableObject {
  
  @ObservedObject var search: AlgoliaSearch<InstantSearchHit>
    
  @Published var suggestionsSearch: AlgoliaSearch<QuerySuggestion>
  
  @Published var searchQuery: String = "" {
    didSet {
      notifyQueryChanged()
    }
  }
  
  @Published var isDisplayingSuggestions: Bool
      
  private var didSubmitSuggestion: Bool
  
  init() {
    search = AlgoliaSearch<InstantSearchHit>(applicationID: "latency",
                                             apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                             indexName: "instant_search")
    suggestionsSearch = AlgoliaSearch<QuerySuggestion>(applicationID: "latency",
                                                       apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                                       indexName: "query_suggestions")
    isDisplayingSuggestions = false
    didSubmitSuggestion = false
  }
  
  func completeSuggestion(_ suggestion: String) {
    searchQuery = suggestion
  }
    
  func submitSuggestion(_ suggestion: String) {
    didSubmitSuggestion = true
    searchQuery = suggestion
  }
  
  func initializeSuggestions() {
    Task {
      _ = try await suggestionsSearch.fetchInitialPage()
      isDisplayingSuggestions = true
    }
  }
  
  func submitSearch() {
    isDisplayingSuggestions = false
    search.request.searchParameters.query = searchQuery
  }
  
  private func notifyQueryChanged() {
    if didSubmitSuggestion {
      didSubmitSuggestion = false
      submitSearch()
    } else {
      isDisplayingSuggestions = true
      suggestionsSearch.request.searchParameters.query = searchQuery
      if searchQuery.isEmpty {
        search.request.searchParameters.query = ""
      }
    }
  }
  
}
