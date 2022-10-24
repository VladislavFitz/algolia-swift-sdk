@testable import AlgoliaSearchClientSwiftModern
import XCTest

final class TestSearchParameters: XCTestCase {
  func testURLEncoding() {
    let query = SearchParameters {
      Query("search it")
      Page(1)
      HitsPerPage(10)
      FacetQuery("facet query")
      AroundPrecision(100)
      AroundRadius(.all)
    }
    print(query.urlEncodedString)
  }
}
