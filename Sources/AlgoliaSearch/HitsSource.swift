//
//  HitsSource.swift
//  
//
//  Created by Vladislav Fitc on 07.04.2023.
//

import Foundation

public protocol HitsSource<Object> {
  
  associatedtype Object
  
  func fetchHits(forPage page: Int) async throws -> ([Object], canLoadMore: Bool)
  
}
