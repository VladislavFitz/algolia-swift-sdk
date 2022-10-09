@testable import AlgoliaSearchClientSwiftModern
import XCTest

final class TestSearchParameters: XCTestCase {
  func testURLEncoding() {
    let query = SearchParameters {
      Query("search it")
      Page(1)
      HitsPerPage(10)
      FacetQuery("facet query")
    }
    print(query.urlEncodedString)
  }
}
