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
  
  @StateObject var viewModel = SearchViewModel()
  
  public init() {}
  
  public var body: some View {
    VStack {
      SearchResultsView(search: viewModel.search)
    }
    .onAppear {
      viewModel.initializeSuggestions()
    }
    .searchable(text: $viewModel.searchQuery,
                prompt: "Laptop, smartphone, tv",
                suggestions: {
      if viewModel.isDisplayingSuggestions {
        SearchSuggestionsView(search: viewModel.suggestionsSearch,
                              onSubmission: viewModel.submitSuggestion,
                              onCompletion: viewModel.completeSuggestion)
      }
    })
    .onSubmit(of: .search, viewModel.submitSearch)
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
