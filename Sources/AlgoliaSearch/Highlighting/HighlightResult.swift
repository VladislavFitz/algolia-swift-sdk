//
//  HighlightResult.swift
//  
//
//  Created by Vladislav Fitc on 07.05.2023.
//

import Foundation
import AlgoliaFoundation
import UIKit

public struct HighlightResultP: Decodable {
  
  let content: JSON
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    content = try container.decode(JSON.self)
  }
  
  public subscript(path: String) -> String? {
    return rawHighlighted(forPath: path)
  }
    
  private func rawHighlighted(forPath path: String) -> String? {
    let components = path.split(separator: ".").map(String.init)
    if components.isEmpty {
      return nil
    }
    var currentContent: JSON? = content
    for component in components {
      currentContent = currentContent?[component]
    }
    return currentContent?["value"]?.string
  }
  
}
