//
//  AlgoliaHitsPage.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation
import AlgoliaFoundation

public struct AlgoliaHitsPage: Page {

  public let page: Int
  public let items: [JSON]
  public let hasPrevious: Bool
  public let hasNext: Bool
  
  init(page: Int,
       hits: [JSON],
       hasPrevious: Bool,
       hasNext: Bool) {
    self.page = page
    self.items = hits
    self.hasPrevious = hasPrevious
    self.hasNext = hasNext
  }
  
  public static func < (lhs: AlgoliaHitsPage, rhs: AlgoliaHitsPage) -> Bool {
    lhs.page < rhs.page
  }
  
  public static func == (lhs: AlgoliaHitsPage, rhs: AlgoliaHitsPage) -> Bool {
    lhs.page == rhs.page
  }
  
}

