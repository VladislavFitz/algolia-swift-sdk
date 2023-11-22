//
//  SearchResponse.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

/// `SearchResponse` is a generic protocol that defines the required interface for a search response
/// that provides paginated data conforming to the `Page` protocol.
/// A custom type conforming to this protocol should be able to fetch a page of data.
///
/// Usage:
/// ```
/// struct CustomSearchResponse: SearchResponse {
///   typealias HitsPage = CustomPage
///
///   func fetchPage() -> CustomPage { ... }
/// }
/// ```
///
/// - Note: The `HitsPage` associated type represents the page type that conforms to the `Page` protocol.
public protocol SearchResponse {

  /// The associated page type that conforms to the `Page` protocol.
  associatedtype HitsPage: Page

  /// Fetches a page of data.
  ///
  /// - Returns: A `HitsPage` containing the data.
  func fetchPage() -> HitsPage

}
