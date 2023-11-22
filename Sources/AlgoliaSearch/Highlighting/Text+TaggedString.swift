//
//  Text+HighlightResult.swift
//  
//
//  Created by Vladislav Fitc on 07.05.2023.
//

import Foundation
import SwiftUI
import AlgoliaSearchClient

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension SwiftUI.Text {
  /**
   - parameter taggedString: HighlightResult value
   - parameter untagged: Text builder for a untagged substring
   - parameter tagged: Text builder for a tagged substring
   */
  init?(taggedString: String,
        @ViewBuilder tagged: @escaping (String) -> Text = { Text($0).foregroundColor(.accentColor) },
        @ViewBuilder untagged: @escaping (String) -> Text = { Text($0) }) {
    let taggedString = TaggedString.algoliaHighlightedString(taggedString)
    let output = taggedString.output
    let ranges = taggedString.taggedRanges
    self = ranges
      .map { (range, isTagged) in (String(output[range]), isTagged) }
      .map { (substring, isTagged) in isTagged ? tagged(substring) : untagged(substring) }
      .reduce(Text(""), +)
  }

}
