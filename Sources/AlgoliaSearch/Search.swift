//
//  Search.swift
//
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Combine
import Foundation
import Logging

/// `Search` is a generic class that manages search operations using a search service conforming to the
/// `SearchService` protocol. It is also an observable object and a page source conforming to the
/// `PageSource` protocol.
///
/// The class is responsible for handling search requests and fetching search responses, as well as managing
/// the `PaginatedDataViewModel` object, which represents the paginated results.
///
/// Usage:
/// ```
/// let searchService = CustomSearchService()
/// let initialRequest = CustomSearchRequest(...)
/// let search = Search(service: searchService, request: initialRequest)
/// ```
///
/// - Note: The `Service` type parameter represents the type of the search service to be used,
///         which conforms to the `SearchService` protocol.
public class Search<Service: SearchService, RF: PaginationRequestFactory>: ObservableObject where RF.Request == Service.Request, RF.HitsPage == Service.Response.HitsPage {
  /// The current search request. When updated, it will reset and reload the hits if the request is different.
  @Published public var request: Service.Request

  /// The `InfiniteListViewModel` object representing the paginated search results.
  @Published public var hits: PaginatedDataViewModel<Service.Response.HitsPage>!

  /// The latest search response fetched by the search service.
  @Published public var latestResponse: Service.Response?

  /// A `Logger` object for logging purposes.
  public var logger: Logger

  /// The search service conforming to the `SearchService` protocol.
  private let service: Service

  private let requestFactory: RF

  private var cancellables: Set<AnyCancellable>

  /// Initializes a new `Search` object with the provided search service, initial request, and log level.
  ///
  /// - Parameters:
  ///   - service: The search service conforming to the `SearchService` protocol.
  ///   - request: The initial search request.
  ///   - logLevel: The log level for the `Logger`. Default is `.warning`.
  public init(service: Service,
              request: Service.Request,
              factory: RF,
              logLevel: Logger.Level = .warning) {
    self.service = service
    self.request = request
    requestFactory = factory
    latestResponse = .none
    var logger = Logger(label: "Search")
    logger.logLevel = logLevel
    self.logger = logger
    cancellables = []
    hits = PaginatedDataViewModel(source: self)
  }

}

// MARK: - PageSource Conformance

extension Search: PageSource {
  /// The associated data type for the items in the pages.
  public typealias Item = Service.Response.HitsPage.Item

  /// The associated page type that conforms to the `Page` protocol.
  public typealias Page = Service.Response.HitsPage

  @MainActor
  public func fetchInitialPage() async throws -> Page {
    request = requestFactory.forInitialPage(from: request)
    let response = try await service.fetchResponse(for: request)
    latestResponse = response
    return response.fetchPage()
  }

  @MainActor
  public func fetchPage(before page: Page) async throws -> Page {
    request = requestFactory.forPage(from: request, before: page)
    let response = try await service.fetchResponse(for: request)
    latestResponse = response
    return response.fetchPage()
  }

  @MainActor
  public func fetchPage(after page: Page) async throws -> Page {
    request = requestFactory.forPage(from: request, after: page)
    let response = try await service.fetchResponse(for: request)
    latestResponse = response
    return response.fetchPage()
  }
}
