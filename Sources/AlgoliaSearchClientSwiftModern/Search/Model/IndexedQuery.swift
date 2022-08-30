//
//  IndexedQuery.swift
//
//
//  Created by Vladislav Fitc on 29.08.2022.
//

import Foundation

/// The composition of search parameters with an associated index name
public struct IndexedQuery {
  /// The name of the index to search in.
  public let indexName: IndexName

  /// The Query to filter results.
  public let searchParameters: SearchParameters

  /// - parameter indexName: The name of the index to search in.
  /// - parameter searchParameters: The search parameters to filter results.
  public init(indexName: IndexName, searchParameters: SearchParameters) {
    self.indexName = indexName
    self.searchParameters = searchParameters
  }
}

extension IndexedQuery: Encodable {
  enum CodingKeys: String, CodingKey {
    case indexName
    case params
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(indexName, forKey: .indexName)
    try container.encode(searchParameters.urlEncodedString, forKey: .params)
  }
}
