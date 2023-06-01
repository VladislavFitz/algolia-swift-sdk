//
//  SearchHeaderPanel.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import AlgoliaFoundation
import SwiftUI

@available(iOS 14.0, *)
public struct SearchHeaderPanel: View {
    
  let indices: [(name: IndexName, title: String)]
  @Binding var indexName: IndexName
  var resultsCount: Int
  
  public var body: some View {
    HStack{
      Text("Results: \(resultsCount)")
      Spacer()
      indexSelectionMenu()
    }.padding(.horizontal)
  }
  
  @ViewBuilder func indexSelectionMenu() -> some View {
    Menu {
      ForEach(indices, id: \.name) { index in
        Button(index.title) {
          indexName = index.name
        }
      }
    } label: {
      Label(title(for: indexName),
            systemImage: "arrow.up.arrow.down")
    }
  }
  
  private func title(for indexName: IndexName) -> String {
    indices.first(where: { $0.name == indexName })?.title ?? ""
  }
    
}
