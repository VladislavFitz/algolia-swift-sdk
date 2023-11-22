//
//  SuggestionRow.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import SwiftUI
import AlgoliaFoundation

public struct SuggestionRow: View {

  let suggestion: QuerySuggestion

  var onSubmission: ((String) -> Void)?
  var onCompletion: ((String) -> Void)?

  init(suggestion: QuerySuggestion,
       onSubmission: ((String) -> Void)? = nil,
       onCompletion: ((String) -> Void)? = nil) {
    self.suggestion = suggestion
    self.onSubmission = onSubmission
    self.onCompletion = onCompletion
  }

  public var body: some View {
    HStack {
      Button(action: {
        onSubmission?(suggestion.query)
      }, label: {
          HStack {
            Image(systemName: "magnifyingglass")
              .padding(.leading, 3)
            if let highlightedName = suggestion._highlightResult["query"] {
              Text(taggedString: highlightedName,
                   tagged: { Text($0).fontWeight(.regular) },
                   untagged: { Text($0).fontWeight(.semibold) })
              .frame(maxWidth: .infinity, alignment: .leading)
            } else {
              Text(suggestion.query)
            }
          }
          .foregroundColor(.black)
      })
      .buttonStyle(.borderless)
      Spacer()
      Button {
        onCompletion?(suggestion.query)
      } label: {
        Image(systemName: "arrow.up.backward")
          .padding(.trailing, 3)
      }
      .buttonStyle(.borderless)
    }
  }

}

class SuggestionRow_Preview: PreviewProvider {

  static var previews: some View {
    List {
      SuggestionRow(suggestion: QuerySuggestion(objectID: "object",
                                                query: "Apple",
                                                popularity: 0,
                                                _highlightResult: HighlightResult(content: ["query": ["value": "<em>App</em>le"]])))
      SuggestionRow(suggestion: QuerySuggestion(objectID: "object",
                                                query: "Apple",
                                                popularity: 0,
                                                _highlightResult: HighlightResult(content: ["query": ["value": "<em>App</em>le"]])))
      SuggestionRow(suggestion: QuerySuggestion(objectID: "object",
                                                query: "Apple",
                                                popularity: 0,
                                                _highlightResult: HighlightResult(content: ["query": ["value": "<em>App</em>le"]])))

    }
  }

}
