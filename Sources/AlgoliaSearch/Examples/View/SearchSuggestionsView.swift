//
//  SearchSuggestionsView.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct SearchSuggestionsView<ViewModel: SuggestionViewModel>: View {
  
  @ObservedObject var viewModel: ViewModel
  var onSubmission: ((String) -> Void)?
  var onCompletion: ((String) -> Void)?
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
      ForEach(viewModel.suggestions, id: \.objectID) { suggestion in
        SuggestionRow(suggestion: suggestion,
                      onSubmission: viewModel.submitSuggestion,
                      onCompletion: viewModel.completeSuggestion)
      }
  }
  
}
