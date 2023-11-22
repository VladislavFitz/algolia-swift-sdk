//
//  InstantSearchHit.swift
//
//
//  Created by Vladislav Fitc on 07.05.2023.
//

import AlgoliaFoundation
import Foundation

struct InstantSearchHit: Decodable & Equatable {
  let name: String
  let price: Float
  let description: String
  let image: URL
  let _highlightResult: HighlightResult
}
