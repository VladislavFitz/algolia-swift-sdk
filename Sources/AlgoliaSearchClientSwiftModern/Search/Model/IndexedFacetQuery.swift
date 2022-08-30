//
//  IndexedFacetQuery.swift
//
//
//  Created by Vladislav Fitc on 29.08.2022.
//

import Foundation

/// The composition of search for facet values parameters with an associated index name
public struct IndexedFacetQuery {
  /// The name of the index to search in.
  public let indexName: IndexName

  /// The attribute to facet on.
  public let attribute: Attribute

  /// Search parameters to filter results.
  public let searchParameters: SearchParameters

  /**
   - Parameter indexName: The name of the index to search in
   - Parameter attribute: The Attribute to facet on.
   - Parameter searchParameters: The search parameters to filter results.
   */
  public init(indexName: IndexName,
              attribute: Attribute,
              searchParameters: SearchParameters) {
    self.indexName = indexName
    self.attribute = attribute
    self.searchParameters = searchParameters
  }
}

extension IndexedFacetQuery: Encodable {
  enum CodingKeys: String, CodingKey {
    case indexName
    case params
    case type
    case facet
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode("facet", forKey: .type)
    try container.encode(indexName, forKey: .indexName)
    try container.encode(searchParameters.urlEncodedString, forKey: .params)
    try container.encode(attribute, forKey: .facet)
  }
}
