//
//  SearchSuggestionsView.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import SwiftUI

public struct SearchSuggestionsView: View {
  
  @ObservedObject var suggestionsSearch: AlgoliaSearch<QuerySuggestion>

  var onSubmission: ((String) -> Void)?
  var onCompletion: ((String) -> Void)?
  
  init(suggestionsSearch: AlgoliaSearch<QuerySuggestion>,
       onSubmission: ((String) -> Void)? = nil,
       onCompletion: ((String) -> Void)? = nil) {
    self.suggestionsSearch = suggestionsSearch
    self.onSubmission = onSubmission
    self.onCompletion = onCompletion
  }
  
  public var body: some View {
    if
      let response = suggestionsSearch.latestResponse,
      let suggestions: [QuerySuggestion] = try? response.fetchHits(), !suggestions.isEmpty {
      ForEach(suggestions, id: \.objectID) { suggestion in
        SuggestionRow(suggestion: suggestion,
                      onSubmission: { onSubmission?($0) },
                      onCompletion: { onCompletion?($0) })
      }
    } else {
      Text("No suggestions")
    }
  }
  
}
