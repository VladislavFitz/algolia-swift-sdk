//
//  SearchResponse+Extract.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaSearchClient
import AlgoliaFoundation

extension AlgoliaSearchClient.SearchResponse: SearchResponse {
  
  func fetchHits<T: Decodable>() throws -> [T] {
    let hitsData = try JSONEncoder().encode(hits)
    return try JSONDecoder().decode([T].self, from: hitsData)
  }
    
  public func fetchPage() -> AlgoliaHitsPage {
    AlgoliaHitsPage(page: page!,
                    hits: try! fetchHits(),
                    hasPrevious: page! > 0,
                    hasNext: page! < nbPages!-1)
  }
  
  
}
