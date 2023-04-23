//
//  SearchResponse.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

public protocol SearchResponse {
  
  associatedtype HitsPage: Page

  func fetchPage() -> HitsPage
  
}
