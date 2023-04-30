//
//  HitsPreview.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation
import SwiftUI
import AlgoliaSearchClient
import AlgoliaFoundation

@available(iOS 15.0, *)
class HitsPreview: PreviewProvider {
  
  static let source = AlgoliaSearch<JSON>(applicationID: "latency",
                                          apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                          indexName: "bestbuy")
  
  static var previews: some View {
    NavigationView {
      InfiniteList(InfiniteListViewModel(source: source), item: { hit in
        Text("Hit found")
      }, noResults: {
        Text("No results found")
      })
      .searchable(text: .constant("hey"))
    }
    
  }
  
}
