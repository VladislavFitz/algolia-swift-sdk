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
    InfiniteList(viewModel.search.hits, item: { hit in
      HitRow(hit: hit)
        .padding()
      Divider()
    }, noResults: {
      Text("No results found")
    })
    .searchable(text: $viewModel.searchQuery,
                prompt: "Laptop, smartphone, tv",
                suggestions: {
      if viewModel.isDisplayingSuggestions {
        SearchSuggestionsView(viewModel: viewModel)
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
