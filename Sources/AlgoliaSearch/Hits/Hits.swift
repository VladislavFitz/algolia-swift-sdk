//
//  Hits.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation

public final class Hits<Source: PageSource>: ObservableObject {
  
  @Published public var hits: [Source.Item]
  @Published public var isLoading: Bool
  @Published public var hasPrevious: Bool
  @Published public var hasNext: Bool
  
  let source: Source
  private let pageStorage: PageStorage<Source.ItemsPage>
  
  public init(source: Source) {
    self.source = source
    self.pageStorage = PageStorage()
    self.isLoading = false
    self.hits = []
    self.hasPrevious = false
    self.hasNext = true
  }
  
  public func loadNext() {
    Task { @MainActor in
      let page: Source.ItemsPage
      if let maxPage = await pageStorage.pages.last, maxPage.hasNext {
        page = try await source.fetchPage(after: maxPage)
      } else {
        page = try await source.fetchInitialPage()
      }
      await pageStorage.append(page)
      hits = await pageStorage.pages.flatMap(\.items)
      hasNext = page.hasNext
    }
  }
  
  public func loadPrevious() {
    Task { @MainActor in
      if let minPage = await pageStorage.pages.first, minPage.hasPrevious {
        let page = try await source.fetchPage(before: minPage)
        await pageStorage.prepend(page)
        hits = await pageStorage.pages.flatMap(\.items)
        hasPrevious = page.hasPrevious
      }
    }
  }
  
  @MainActor
  internal func reset() async {
    await pageStorage.clear()
    hits = []
    hasPrevious = false
    hasNext = true
  }

  
  public enum Error: LocalizedError {
    case indexOutOfRange
    case requestError(Swift.Error)
    
    public var errorDescription: String? {
      switch self {
      case .requestError(let error):
        return "Error occured during search request: \(error)"
      case .indexOutOfRange:
        return "Attempt to access the hit on unaccessible page"
      }
    }
  }
  
}
