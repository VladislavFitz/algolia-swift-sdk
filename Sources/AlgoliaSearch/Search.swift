//
//  Search.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation
import Logging

public final class Search<Service: SearchService>: ObservableObject where Service.Request.HitsPage == Service.Response.HitsPage {
  
  @Published public var request: Service.Request {
    didSet {
      if request.isDifferent(to: oldValue) {
        Task {
          await hits.reset()
          hits.loadNext()
        }
      }
    }
  }
  
  @Published public var hits: Hits<Search>!
  @Published public var latestResponse: Service.Response?
  
  public var logger: Logger
  private let service: Service
  
  public init(service: Service,
              request: Service.Request,
              logLevel: Logger.Level = .warning) {
    self.service = service
    self.request = request
    self.latestResponse = .none
    var logger = Logger(label: "Search")
    logger.logLevel = logLevel
    self.logger = logger
    self.hits = Hits(source: self)
  }
  
}

extension Search: PageSource {
  
  public typealias Item = Service.Request.HitsPage.Item
  public typealias Page = Service.Request.HitsPage
  
  @MainActor
  public func fetchInitialPage() async throws -> Page {
    request = request.forInitialPage()
    let response = try await service.fetchResponse(for: request)
    latestResponse = response
    return response.fetchPage()
  }
  
  @MainActor
  public func fetchPage(before page: Page) async throws -> Page {
    request = request.forPage(before: page)
    let response = try await service.fetchResponse(for: request)
    latestResponse = response
    return response.fetchPage()
  }
  
  @MainActor
  public func fetchPage(after page: Page) async throws -> Page {
    request = request.forPage(after: page)
    let response = try await service.fetchResponse(for: request)
    latestResponse = response
    return response.fetchPage()
  }
  
}
