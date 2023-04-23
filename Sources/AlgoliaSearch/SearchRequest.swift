//
//  SearchRequest.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

public protocol SearchRequest {
  
  associatedtype HitsPage: Page
  
  func isDifferent(to request: Self) -> Bool
  
  func forInitialPage() -> Self
  func forPage(after page: HitsPage) -> Self
  func forPage(before page: HitsPage) -> Self
  
}
