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
public protocol SearchRequest: Equatable {}
