//
//  SearchResponse.swift
//
//
//  Created by Vladislav Fitc on 08.08.2022.
//

import Foundation

public struct SearchResponse: Decodable {
  /**
   The hits returned by the search. Hits are ordered according to the ranking or sorting of the index being queried.
   Hits are made of the schemaless JSON objects that you stored in the index.
   */
  public var hits: [JSON]

  /**
   The number of hits matched by the query.
   */
  var nbHits: Int?

  /**
    Index of the current page (zero-based). See the Query.page search parameter.
   - Not returned if you use offset/length for pagination.
   */
  public var page: Int?

  /**
    The maximum number of hits returned per page. See the Query.hitsPerPage search parameter.
   - Not returned if you use offset & length for pagination.
   */
  public var hitsPerPage: Int?

  /**
    Returned only by the EndpointSearch.browse method.
   */
  public var cursor: Cursor?
}

public extension SearchResponse {
  func hitsAsListOf<T: Decodable>(_: T.Type) throws -> [T] {
    let hitsData = try JSONEncoder().encode(hits)
    return try JSONDecoder().decode([T].self, from: hitsData)
  }

  /// Returns the position (0-based) within the hits result list of the record matching against the given objectID.
  /// If the objectID is not found, nil is returned.
  func getPositionOfObject(withID objectID: String) -> Int? {
    return hits.firstIndex { .string(objectID) == $0["objectID"] }
  }
}

extension SearchResponse: CustomStringConvertible {
  public var description: String {
    return """
    SearchResponse {
      nbHits: \(nbHits?.description ?? "nil")
      page: \(page?.description ?? "nil")
      hitsPerPage: \(hitsPerPage?.description ?? "nil")
      hits {
      \(hits.map { "\($0.debugDescription)" }.joined(separator: "\n"))
      }
    }
    """
  }
}
