//
//  File.swift
//  
//
//  Created by Vladislav Fitc on 22.11.2023.
//

import Foundation
import AlgoliaFoundation

public extension AlgoliaSearch {
  
  func sortViewModel(indexNames: [IndexName],
                     selectedIndexName: IndexName) -> SelectIndexViewModel {
    let viewModel = SelectIndexViewModel(indexNames: indexNames,
                                         selectedIndexName: selectedIndexName)
    viewModel
      .$selectedIndexName
      .assign(to: \.indexName, on: self)
      .store(in: &cancellables)
    return viewModel
  }
  
}
