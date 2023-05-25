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

struct QuerySuggestion: Decodable {
  
  let objectID: String
  let query: String
  let popularity: Int
  
}

@available(iOS 15.0, *)
public struct SuggestionsView: View {
  
  @StateObject var search = AlgoliaSearch<QuerySuggestion>(applicationID: "latency",
                                                           apiKey: "927c3fe76d4b52c5a2912973f35a3077",
                                                           indexName: "STAGING_native_ecom_demo_products_query_suggestions")
  
  @Environment(\.isSearching) var isSearching
  @Environment(\.dismissSearch) private var dismissSearch
  
  var query: Binding<String>
  var isDisplayingSuggestions: Binding<Bool>
    
  public var body: some View {
    if isDisplayingSuggestions.wrappedValue && isSearching {
      InfiniteList(search.hits, item: { suggestion in
        Button(action: {
          query.wrappedValue = suggestion.query
        }, label: {
          HStack {
            Text(suggestion.query)
          }
        })
        Divider()
      }, noResults: {
        Text("No results found")
      })
//      .onChange(of: query.wrappedValue) { newValue in
//        search.query.wrappedValue = newValue
//      }
    }
  }
  
}

@available(iOS 15.0, *)
public struct SearchView: View {
  
  @StateObject var search = AlgoliaSearch<InstantSearchHit>(applicationID: "latency",
                                                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                                            indexName: "instant_search")
  
  @State var isDisplayingSuggestions: Bool = true
  @State var searchQuery: String = ""
  
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
      .searchable(text: $searchQuery,
                  prompt: "Laptop, smartphone, tv",
                  suggestions: {
        SuggestionsView(query: $searchQuery,
                        isDisplayingSuggestions: $isDisplayingSuggestions)
      })
      .onChange(of: searchQuery, perform: { searchQuery in
        if searchQuery.isEmpty {
          search.query.wrappedValue = ""
//          isDisplayingSuggestions = true
        }
      })
      .onSubmit(of: .search) {
        isDisplayingSuggestions = false
        search.query.wrappedValue = searchQuery
      }
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
