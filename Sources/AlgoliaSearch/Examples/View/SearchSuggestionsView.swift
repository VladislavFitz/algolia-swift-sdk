//
//  SearchSuggestionsView.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
public struct SearchSuggestionsView: View {
  
  @ObservedObject var search: AlgoliaSearch<QuerySuggestion>
  var onSubmission: ((String) -> Void)?
  var onCompletion: ((String) -> Void)?
  
  init(search: AlgoliaSearch<QuerySuggestion>,
       onSubmission: ((String) -> Void)? = nil,
       onCompletion: ((String) -> Void)? = nil) {
    self.search = search
    self.onSubmission = onSubmission
    self.onCompletion = onCompletion
  }
  
  public var body: some View {
    let latestHits = search.fetchLatestHits()
    if latestHits.isEmpty {
      Text("No suggestions")
    } else {
      ForEach(latestHits, id: \.objectID) { suggestion in
        SuggestionRow(suggestion: suggestion,
                      onSubmission: onSubmission,
                      onCompletion: onCompletion)
      }
    }
  }
  
}
