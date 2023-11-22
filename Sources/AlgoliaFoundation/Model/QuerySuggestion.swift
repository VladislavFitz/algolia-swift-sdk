//
//  QuerySuggestion.swift
//  
//
//  Created by Vladislav Fitc on 01.06.2023.
//

import Foundation

/// `QuerySuggestion` is a structure representing a suggested query returned by the Algolia search API.
public struct QuerySuggestion: Decodable & Equatable {

  /// The unique identifier of the query suggestion assigned by Algolia.
  public let objectID: String

  /// The text of the suggested query. This property represents the suggested search term.
  public let query: String

  /// An integer value indicating the popularity of the suggested query.
  /// The higher the value, the more popular the suggestion.
  public let popularity: Int

  /// A `HighlightResult` object that contains the highlighted parts of the suggested query.
  /// This property is particularly useful for the visual representation of search suggestions in a UI,
  /// where it can be used to highlight the matching parts of the suggestion.
  public let _highlightResult: HighlightResult

  public init(objectID: String,
              query: String,
              popularity: Int,
              _highlightResult: HighlightResult) {
    self.objectID = objectID
    self.query = query
    self.popularity = popularity
    self._highlightResult = _highlightResult
  }

}
