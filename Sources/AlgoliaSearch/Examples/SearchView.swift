//
//  SearchExample.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation
import SwiftUI
import AlgoliaSearchClient
import AlgoliaFoundation

@available(iOS 15.0, *)
public struct SearchView: View {
  
  @StateObject var search = AlgoliaSearch<InstantSearchHit>(applicationID: "latency",
                                                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                                            indexName: "instant_search")
    
  @StateObject var suggestionsSearch = AlgoliaSearch<QuerySuggestion>(applicationID: "latency",
                                                                      apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                                                      indexName: "query_suggestions")
  
  @State var searchQuery: String = ""
  @State var isDisplayingSuggestions: Bool = false
  @State var didSubmitSuggestion: Bool = false
    
  public init() {}
      
  public var body: some View {
    VStack {
      SearchHeaderPanel(search: search)
      SearchResultsView(search: search)
    }
    .onAppear {
      Task {
        _ = try await suggestionsSearch.fetchInitialPage()
        isDisplayingSuggestions = true
      }
    }
    .searchable(text: $searchQuery,
                prompt: "Laptop, smartphone, tv",
                suggestions: {
        if isDisplayingSuggestions {
          SearchSuggestionsView(suggestionsSearch: suggestionsSearch,
                                onSubmission: submitSuggestion,
                                onCompletion: completeSuggestion)
        }
    })
    .onChange(of: searchQuery, perform: notifyQueryChanged)
    .onSubmit(of: .search, submitSearch)
  }
  
  private func notifyQueryChanged(_ searchQuery: String) {
    guard didSubmitSuggestion else {
      isDisplayingSuggestions = true
      suggestionsSearch.request.searchParameters.query = searchQuery
      if searchQuery.isEmpty {
        search.request.searchParameters.query = searchQuery
      }
      return
    }
    didSubmitSuggestion = false
    submitSearch()
  }
  
  private func completeSuggestion(_ suggestion: String) {
    searchQuery = suggestion
  }
    
  private func submitSuggestion(_ suggestion: String) {
    didSubmitSuggestion = true
    searchQuery = suggestion
  }
  
  private func submitSearch() {
    isDisplayingSuggestions = false
    search.request.searchParameters.query = searchQuery
  }
  
}

@available(iOS 15.0, *)
class SearchPreview: PreviewProvider {
  
  static var previews: some View {
    NavigationView {
      SearchView()
    }
  }
  
}
