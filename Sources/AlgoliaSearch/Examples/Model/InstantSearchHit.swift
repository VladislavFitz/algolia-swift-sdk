//
//  InstantSearchHit.swift
//  
//
//  Created by Vladislav Fitc on 07.05.2023.
//

import Foundation

struct InstantSearchHit: Decodable {
  let name: String
  let price: Float
  let description: String
  let image: URL
  let _highlightResult: HighlightResultP
}
