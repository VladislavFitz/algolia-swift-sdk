//
//  HighlightResult.swift
//  
//
//  Created by Vladislav Fitc on 07.05.2023.
//

import Foundation

/// `HighlightResult` is a structure that holds the highlighted parts of a query result.
public struct HighlightResult: Decodable & Equatable {

  /// The JSON content containing the highlighted parts of a query result.
  let content: JSON

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    content = try container.decode(JSON.self)
  }

  public init(content: JSON) {
    self.content = content
  }

  /// Subscript that accepts a path as a string and returns the highlighted content as a string,
  /// or `nil` if no highlighted content is found at the specified path.
  public subscript(path: String) -> String? {
    return rawHighlighted(forPath: path)
  }

  /// Private function that accepts a path as a string and returns the highlighted content as a string,
  /// or `nil` if no highlighted content is found at the specified path.
  /// This function uses a depth-first search to traverse the JSON content.
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
