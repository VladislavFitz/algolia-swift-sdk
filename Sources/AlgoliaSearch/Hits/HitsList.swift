//
//  HitsList.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct HitsList<HitView: View, NoResults: View, Source: PageSource>: View {
  
  @StateObject public var hits: Hits<Source>
  
  let hit: (Source.Item) -> HitView
  let noResults: () -> NoResults
  
  public init(_ hits: Hits<Source>,
              @ViewBuilder hitView: @escaping (Source.Item) -> HitView,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    _hits = StateObject(wrappedValue: hits)
    hit = hitView
    self.noResults = noResults
  }
  
  public var body: some View {
    if hits.hits.isEmpty && !hits.hasNext {
      noResults()
        .frame(maxHeight: .infinity)
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
