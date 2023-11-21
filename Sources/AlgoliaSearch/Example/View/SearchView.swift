//
//  SearchExample.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import SwiftUI

@available(iOS 15.0, *)
public struct SearchView: View {
  
  @StateObject var viewModel = SearchViewModel()
  
  public init() {}
  
  public var body: some View {
    VStack {
      InfiniteList(viewModel.hits, item: { hit in
        HitRow(hit: hit)
          .padding()
        Divider()
      }, noResults: {
        Text("No results found")
      })
    }
    .searchable(text: $viewModel.searchQuery,
                prompt: "Laptop, smartphone, tv",
                suggestions: {
      ForEach(viewModel.suggestions, id: \.objectID) { suggestion in
        SuggestionRow(suggestion: suggestion,
                      onSubmission: { viewModel.submitSuggestion($0) },
                      onCompletion: { viewModel.completeSuggestion($0) })
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
