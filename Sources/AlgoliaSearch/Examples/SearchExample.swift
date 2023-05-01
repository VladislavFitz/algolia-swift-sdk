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

struct InstantSearchHit: Decodable {
  let name: String
  let price: Float
  let description: String
  let image: URL
}

@available(iOS 15.0, *)
struct SearchExample: View {
  
  @StateObject var search = AlgoliaSearch<InstantSearchHit>(applicationID: "latency",
                                                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                                            indexName: "instant_search")
  
  var indices: [(name: IndexName, title: String)] = [
    (name: "instant_search", title: "Default"),
    (name: "instant_search_price_asc", title: "Price ↑"),
    (name: "instant_search_price_desc", title: "Price ↓"),
  ]
    
  func title(for indexName: IndexName) -> String {
    indices.first(where: { $0.name == indexName })?.title ?? ""
  }
  
  var body: some View {
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
        HStack {
          AsyncImage(url: hit.image, content: { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          }, placeholder: {
            
          })
          .frame(width: 40, height: 40)
          .padding(.trailing, 10)
          VStack {
            Text(hit.name)
            HStack {
              Spacer()
              Text(String(format: "$%.2f", hit.price))
            }
          }
          Spacer()
        }
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
      SearchExample()
    }
  }
  
}
