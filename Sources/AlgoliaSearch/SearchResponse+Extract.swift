//
//  SearchResponse+Extract.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaSearchClient

public extension SearchResponse {
  
  func fetchHits<T: Decodable>() throws -> [T] {
    let hitsData = try JSONEncoder().encode(hits)
    return try JSONDecoder().decode([T].self, from: hitsData)
  }
  
  var canLoadMore: Bool {
    if let page, let nbPages {
      if page == nbPages-1 {
        return false
      }
    }
    return true
  }
  
}

