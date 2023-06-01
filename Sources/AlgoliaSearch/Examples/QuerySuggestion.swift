//
//  QuerySuggestion.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation

struct QuerySuggestion: Decodable {
  let objectID: String
  let query: String
  let popularity: Int
  let _highlightResult: HighlightResultP
}
