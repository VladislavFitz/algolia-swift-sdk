//
//  SearchHeaderPanel.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import AlgoliaFoundation
import SwiftUI

public final class SearchHeaderViewModel: ObservableObject {
  
  @ObservedObject var search: AlgoliaSearch<InstantSearchHit>
  
  var indices: [(name: IndexName, title: String)]
  
//  = [
//    (name: "instant_search", title: "Default"),
//    (name: "instant_search_price_asc", title: "Price ⏶"),
//    (name: "instant_search_price_desc", title: "Price ⏷"),
//  ]
  
  init(search: AlgoliaSearch<InstantSearchHit>, indices: [(name: IndexName, title: String)]) {
    self.search = search
    self.indices = indices
  }
  
  func title(for indexName: IndexName) -> String {
    indices.first(where: { $0.name == indexName })?.title ?? ""
  }
  
}

@available(iOS 14.0, *)
public struct SearchHeaderPanel: View {
  
  @ObservedObject var viewModel: SearchHeaderViewModel
  
  public var body: some View {
    HStack{
      let response = viewModel.search.latestResponse?.searchResponse
      Text("Results: \(response?.nbHits ?? 0)")
      Spacer()
      indexSelectionMenu()
    }.padding(.horizontal)
  }
  
  @ViewBuilder func indexSelectionMenu() -> some View {
    Menu {
      ForEach(viewModel.indices, id: \.name) { index in
        Button(index.title) {
          viewModel.search.request.indexName = index.name
        }
      }
    } label: {
      Label(viewModel.title(for: viewModel.search.request.indexName),
            systemImage: "arrow.up.arrow.down")
    }
  }
    
}
