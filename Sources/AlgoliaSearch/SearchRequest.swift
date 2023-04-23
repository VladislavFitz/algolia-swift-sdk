//
//  SearchRequest.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

/// `SearchRequest` is a generic protocol that defines the required interface for a search request
/// responsible for fetching paginated data conforming to the `Page` protocol.
/// A custom type conforming to this protocol should be able to check if two requests are different,
/// and create requests for the initial, next, and previous pages.
///
/// Usage:
/// ```
/// struct CustomSearchRequest: SearchRequest {
///   typealias HitsPage = CustomPage
///
///   func isDifferent(to request: CustomSearchRequest) -> Bool { ... }
///   func forInitialPage() -> CustomSearchRequest { ... }
///   func forPage(after page: CustomPage) -> CustomSearchRequest { ... }
///   func forPage(before page: CustomPage) -> CustomSearchRequest { ... }
/// }
/// ```
///
/// - Note: The `HitsPage` associated type represents the page type that conforms to the `Page` protocol.
public protocol SearchRequest {
  
  /// The associated page type that conforms to the `Page` protocol.
  associatedtype HitsPage: Page
  
  /// Compares the current request with another request for a difference.
  ///
  /// - Parameter request: The `SearchRequest` to compare with.
  /// - Returns: A `Bool` indicating whether the two requests are different.
  func isDifferent(to request: Self) -> Bool
  
  /// Creates a new request for the initial page.
  ///
  /// - Returns: A new `SearchRequest` for the initial page.
  func forInitialPage() -> Self
  
  /// Creates a new request for the page after a given page.
  ///
  /// - Parameter page: The `HitsPage` after which to fetch the data.
  /// - Returns: A new `SearchRequest` for the page after the specified page.
  func forPage(after page: HitsPage) -> Self
  
  /// Creates a new request for the page before a given page.
  ///
  /// - Parameter page: The `HitsPage` before which to fetch the data.
  /// - Returns: A new `SearchRequest` for the page before the specified page.
  func forPage(before page: HitsPage) -> Self
  
}
