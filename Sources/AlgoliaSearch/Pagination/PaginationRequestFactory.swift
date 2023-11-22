//
//  PaginationRequestFactory.swift
//
//
//  Created by Vladislav Fitc on 05.10.2023.
//

import Foundation

public protocol PaginationRequestFactory {
  associatedtype Request: SearchRequest

  /// The associated page type that conforms to the `Page` protocol.
  associatedtype HitsPage: Page

  /// Creates a new request for the initial page.
  ///
  /// - Returns: A new `SearchRequest` for the initial page.
  func forInitialPage(from request: Request) -> Request

  /// Creates a new request for the page after a given page.
  ///
  /// - Parameter page: The `HitsPage` after which to fetch the data.
  /// - Returns: A new `SearchRequest` for the page after the specified page.
  func forPage(from request: Request, after page: HitsPage) -> Request

  /// Creates a new request for the page before a given page.
  ///
  /// - Parameter page: The `HitsPage` before which to fetch the data.
  /// - Returns: A new `SearchRequest` for the page before the specified page.
  func forPage(from request: Request, before page: HitsPage) -> Request
}
