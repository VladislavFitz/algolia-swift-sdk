//
//  SearchResultsView.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct SearchResultsView: View {
  
  @ObservedObject var search: AlgoliaSearch<InstantSearchHit>
  
  public var body: some View {
    InfiniteList(search.hits, item: { hit in
      HitRow(hit: hit)
        .padding()
      Divider()
    }, noResults: {
      Text("No results found")
    })
  }
  
}
