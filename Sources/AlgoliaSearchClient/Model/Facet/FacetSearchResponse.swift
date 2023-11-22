//
//  FacetSearchResponse.swift
//
//
//  Created by Vladislav Fitc on 29.08.2022.
//

import AlgoliaFoundation
import Foundation

public struct FacetSearchResponse: Decodable {
  /// The list of Facet.
  public let facetHits: [Facet]

  /// Whether the count returned for each facets is exhaustive.
  public let exhaustiveFacetsCount: Bool

  /// Processing time.
  public let processingTimeMS: TimeInterval
}

extension FacetSearchResponse: CustomStringConvertible {
  public var description: String {
    return """
    FacetSearchResponse {
      exhaustiveFacetsCount: \(exhaustiveFacetsCount)
      processingTime: \(processingTimeMS)
      facets {
    \(facetHits.map { "\t\t\($0.description)" }.joined(separator: "\n"))
      }
    }
    """
  }
}
