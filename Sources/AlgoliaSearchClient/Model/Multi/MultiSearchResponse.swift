import AlgoliaFoundation
import Foundation

/// Wraps the list of multi search results (either FacetSearchResponse or SearchResponse)
struct MultiSearchResponse: Decodable {
  /// List of result in the order they were submitted, one element for each IndexedQuery.
  var results: [Either<SearchResponse, FacetSearchResponse>]

  /// - parameter results: List of result in the order they were submitted, one element for each IndexedQuery.
  init(results: [Either<SearchResponse, FacetSearchResponse>]) {
    self.results = results
  }
}
