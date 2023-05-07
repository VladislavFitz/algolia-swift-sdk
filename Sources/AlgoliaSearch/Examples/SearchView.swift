//
//  SearchExample.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation
import SwiftUI
import AlgoliaSearchClient
import AlgoliaFoundation

@available(iOS 15.0, *)
public struct SearchView: View {
  
  @StateObject var search = AlgoliaSearch<InstantSearchHit>(applicationID: "latency",
                                                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                                            indexName: "instant_search")
  
  var indices: [(name: IndexName, title: String)] = [
    (name: "instant_search", title: "Default"),
    (name: "instant_search_price_asc", title: "Price ↑"),
    (name: "instant_search_price_desc", title: "Price ↓"),
  ]
  
  public init() {}
  
  func title(for indexName: IndexName) -> String {
    indices.first(where: { $0.name == indexName })?.title ?? ""
  }
  
  public var body: some View {
    VStack {
      HStack{
        let response = search.latestResponse?.searchResponse
        Text("Results: \(response?.nbHits ?? 0)")
        Spacer()
        Menu {
          ForEach(indices, id: \.name) { index in
            Button(index.title) {
              search.indexName.wrappedValue = index.name
            }
          }
        } label: {
          Label("Sort: \(title(for: search.indexName.wrappedValue))",
                systemImage: "arrow.up.arrow.down")
        }
      }.padding(.horizontal)
      InfiniteList(search.hits, item: { hit in
        HitRow(hit: hit)
          .padding()
        Divider()
      }, noResults: {
        Text("No results found")
      })
      .searchable(text: search.query)
    }
    
  }
  
}


@available(iOS 15.0, *)
class SearchPreview: PreviewProvider {
  
  static let search = AlgoliaSearch<InstantSearchHit>(applicationID: "latency",
                                                      apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                                      indexName: "instant_search")
  
  static var indices: [(name: IndexName, title: String)] = [
    (name: "instant_search", title: "Default"),
    (name: "instant_search_price_asc", title: "Price ↑"),
    (name: "instant_search_price_desc", title: "Price ↓"),
  ]
  
  static var previews: some View {
    NavigationView {
      SearchView()
    }
  }
  
}
