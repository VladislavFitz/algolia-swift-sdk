//
//  Page.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

public protocol Page<Item>: Comparable {
  
  associatedtype Item
    
  var hasPrevious: Bool { get }
  var hasNext: Bool { get }
  
  var items: [Item] { get }
  
}
