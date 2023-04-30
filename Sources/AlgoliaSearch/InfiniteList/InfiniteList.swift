//
//  InfiniteList.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import SwiftUI

/// `InfiniteList` is a SwiftUI generic view responsible for displaying a list of paginated data provided by the `InfiniteScrollViewModel` class.
/// It provides an easy way to render hits as well as handling pagination and no results view.
///
/// Usage:
/// ```
/// let infiniteList = InfiniteList(source: CustomPageSource())
/// let infiniteList = InfiniteList(hits, hitView: { hit in
///   Text(hit.title)
/// }, noResults: {
///   Text("No results found")
/// })
/// ```
///
/// - Note: This view is available from iOS 15.0 onwards.
@available(iOS 15.0, macOS 12.0, *)
public struct InfiniteList<HitView: View, NoResults: View, Item, P: Page<Item>>: View {
  
  /// An instance of `InfiniteScrollViewModel` object.
  @StateObject public var viewModel: InfiniteListViewModel<P>
  
  /// A closure that returns a `HitView` for a given `Source.Item`.
  let itemView: (Item) -> HitView
  
  /// A closure that returns a `NoResults` view to display when there are no hits.
  let noResults: () -> NoResults
  
  /// Initializes a new instance of `HitsList` with the provided `hits`, `hitView` and `noResults` closures.
  ///
  /// - Parameters:
  ///   - hits: An instance of `InfiniteScrollViewModel` object.
  ///   - hitView: A closure that returns a `HitView` for a given `Source.Item`.
  ///   - noResults: A closure that returns a `NoResults` view to display when there are no hits.
  public init(_ hits: InfiniteListViewModel<P>,
              @ViewBuilder item: @escaping (Item) -> HitView,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    _viewModel = StateObject(wrappedValue: hits)
    self.itemView = item
    self.noResults = noResults
  }
  
  public var body: some View {
    if viewModel.items.isEmpty && !viewModel.hasNext {
      noResults()
        .frame(maxHeight: .infinity)
    } else {
      ScrollView {
        LazyVStack {
          if viewModel.hasPrevious {
            ProgressView()
              .task {
                viewModel.loadPrevious()
              }
          }
          ForEach(0..<viewModel.items.count, id: \.self) { index in
            itemView(viewModel.items[index])
          }
          if viewModel.hasNext {
            ProgressView()
              .task {
                viewModel.loadNext()
              }
          }
        }
      }
    }
  }
  
}
