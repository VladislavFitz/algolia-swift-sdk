//
//  Hits.swift
//  
//
//  Created by Vladislav Fitc on 01.04.2023.
//

import Foundation

public final class Hits<Object>: ObservableObject {
  
  @Published public var hits: [Object]
  @Published public var isLoading: Bool
  @Published public var hasPrevious: Bool
  @Published public var hasNext: Bool
  
  public func loadNext() {
    guard hasNext else { return }
    Task {
      let maxPageIndex = await pageStorage.pages.keys.max() ?? -1
      let nextPageIndex = maxPageIndex + 1
      try await loadPage(atIndex: nextPageIndex)
    }
  }
  
  public func loadPrevious() {
    guard hasPrevious else { return }
    Task {
      let minPageIndex = await pageStorage.pages.keys.min() ?? -1
      guard minPageIndex > 0 else { return }
      let previousPageIndex = minPageIndex - 1
      try await loadPage(atIndex: previousPageIndex)
    }
  }
  
  @MainActor
  internal func reset() async {
    await pageStorage.clear()
    hits = []
    hasPrevious = false
    hasNext = true
  }
  
  private func loadPage(atIndex index: Int) async throws {
    let loadedPage: [Object]
    let canLoadMore: Bool
    Task { @MainActor in
      isLoading = true
    }
    defer {
      Task { @MainActor in
        isLoading = false
      }
    }
    do {
      (loadedPage, canLoadMore) = try await source.fetchHits(forPage: index)
    } catch let error {
      throw Error.requestError(error)
    }
    await pageStorage.set(hits: loadedPage, forPageAtIndex: index)
    let hits = await pageStorage.pages.sorted(by: { $0.key < $1.key }).flatMap(\.value)
    Task { @MainActor in
      self.hits = hits
      if index == 0 {
        hasPrevious = false
      }
      hasNext = canLoadMore
    }
  }
  
  let source: any HitsSource<Object>
        
  private let pageStorage: PageStorage
  
  private actor PageStorage {
    var pages: [Int: [Object]]
    init(pages: [Int : [Object]]) {
      self.pages = pages
    }
    
    func set(hits: [Object], forPageAtIndex pageIndex: Int) {
      pages[pageIndex] = hits
    }
    
    func clear() {
      pages.removeAll()
    }
  }
  
  public init(source: some HitsSource<Object>,
              pages: [Int: [Object]] = [:]) {
    self.source = source
    self.pageStorage = PageStorage(pages: pages)
    self.isLoading = false
    self.hits = []
    self.hasPrevious = false
    self.hasNext = true
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
