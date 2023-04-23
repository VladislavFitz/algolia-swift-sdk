//
//  HitsPreview.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation
import SwiftUI
import AlgoliaSearchClient

@available(iOS 15.0, *)
class HitsPreview: PreviewProvider {
  
  static let source = AlgoliaHitsSource(client: SearchClient(appID: "latency",
                                                             apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db"),
                                        query: IndexedQuery(indexName: "bestbuy"))
  
  static var previews: some View {
    NavigationView {
      HitsList(Hits(source: source), hitView: { hit in
        Text("Hit found")
      }, noResults: {
        Text("No results found")
      })
      .searchable(text: .constant("hey"))
    }
    
  }
  
}
