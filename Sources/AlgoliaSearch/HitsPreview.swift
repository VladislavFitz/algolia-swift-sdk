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
public struct HitsList<Hit: View, NoResults: View>: View {
  
  @StateObject public var hits: Hits<JSON>
  
  let hit: (JSON) -> Hit
  let noResults: () -> NoResults
  
  public init(_ hits: Hits<JSON>,
              @ViewBuilder hitView: @escaping (JSON) -> Hit,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    _hits = StateObject(wrappedValue: hits)
    hit = hitView
    self.noResults = noResults
  }
  
  public var body: some View {
    if hits.hits.isEmpty {
      noResults()
    } else {
      ScrollView {
        LazyVStack {
          if hits.hasPrevious {
            ProgressView()
              .task {
                hits.loadPrevious()
              }
          }
          ForEach(0..<hits.hits.count, id: \.self) { index in
            hit(hits.hits[index])
          }
          if hits.hasNext {
            ProgressView()
              .task {
                hits.loadNext()
              }
          }
        }
      }
    }
  }
  
}

@available(iOS 15.0, *)
extension HitsList {
  
  public init(appID: ApplicationID,
              apiKey: APIKey,
              indexName: IndexName,
              @ViewBuilder hitView: @escaping (JSON) -> Hit,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    let client = SearchClient(appID: "latency",
                              apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
    let query = IndexedQuery(indexName: "bestbuy")
    let source = AlgoliaHitsSource(client: client,
                                   query: query)
    self.init(Hits(source: source),
              hitView: hitView,
              noResults: noResults)
  }
  
}


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
