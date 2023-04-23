//
//  HitsSource.swift
//  
//
//  Created by Vladislav Fitc on 07.04.2023.
//

import Foundation

public protocol PageSource {
    
  associatedtype Item
  associatedtype ItemsPage: Page<Item>
  
  func fetchInitialPage() async throws -> ItemsPage
    
  func fetchPage(before page: ItemsPage) async throws -> ItemsPage
  
  func fetchPage(after page: ItemsPage) async throws -> ItemsPage
  
}
