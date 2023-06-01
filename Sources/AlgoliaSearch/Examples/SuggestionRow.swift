//
//  SuggestionRow.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import SwiftUI

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
        if let highlightedName = suggestion._highlightResult["query"] {
          HStack {
            Image(systemName: "magnifyingglass")
              .padding(.leading, 3)
            Text(taggedString: highlightedName,
                 tagged: { Text($0).fontWeight(.regular) },
                 untagged: { Text($0).fontWeight(.semibold) })
            .frame(maxWidth: .infinity, alignment: .leading)
          }
          .foregroundColor(.black)
        }
      })
      .buttonStyle(.borderless)
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
