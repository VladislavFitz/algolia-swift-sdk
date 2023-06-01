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
  
  @ObservedObject var search: AlgoliaSearch<InstantSearchHit>
  
  var indices: [(name: IndexName, title: String)] = [
    (name: "instant_search", title: "Default"),
    (name: "instant_search_price_asc", title: "Price ⏶"),
    (name: "instant_search_price_desc", title: "Price ⏷"),
  ]
  
  public var body: some View {
    HStack{
      let response = search.latestResponse?.searchResponse
      Text("Results: \(response?.nbHits ?? 0)")
      Spacer()
      indexSelectionMenu()
    }.padding(.horizontal)
  }
  
  @ViewBuilder func indexSelectionMenu() -> some View {
    Menu {
      ForEach(indices, id: \.name) { index in
        Button(index.title) {
          search.request.indexName = index.name
        }
      }
    } label: {
      Label(title(for: search.request.indexName),
            systemImage: "arrow.up.arrow.down")
    }
  }
  
  private func title(for indexName: IndexName) -> String {
    indices.first(where: { $0.name == indexName })?.title ?? ""
  }
  
}
