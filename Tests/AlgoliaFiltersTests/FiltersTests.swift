@testable import AlgoliaFilters
import Combine
import Foundation
import XCTest

class FiltersTests: XCTestCase {
  var filtersSubscription: AnyCancellable?
  var andGroupSubscription: AnyCancellable?
  var orGroupSubscription: AnyCancellable?

  var cancellables: Set<AnyCancellable> = []

  func testAndFilterGroup() {
    let group = AndFilterGroup()
    let exp = expectation(description: "filters observer")
    exp.expectedFulfillmentCount = 7
    andGroupSubscription = group.$filters.sink { _ in
      exp.fulfill()
    }
    let tagFilter = "someTag" as TagFilter
    let facetFilter = FacetFilter(attribute: "size", value: 36)
    let numericFilter = NumericFilter(attribute: "price", range: 1 ... 10)
    group.add(tagFilter)
    group.add(facetFilter)
    group.add(numericFilter)
    XCTAssertEqual(group.description, """
    ( "_tags":"someTag" AND "price":1.0 TO 10.0 AND "size":"36.0" )
    """)
    XCTAssertEqual(group.filters(withAttribute: "size").first as? FacetFilter, facetFilter)
    group.remove(facetFilter)
    XCTAssertEqual(group.description, """
    ( "_tags":"someTag" AND "price":1.0 TO 10.0 )
    """)
    group.removeFilters(withAttribute: "price")
    XCTAssertEqual(group.description, """
    ( "_tags":"someTag" )
    """)
    group.removeAll()
    XCTAssertTrue(group.isEmpty)
    XCTAssertEqual(group.description, "")
    wait(for: [exp], timeout: 1)
  }

  func testOrFilterGroup() {
    let group = OrFilterGroup<FacetFilter>()
    let exp = expectation(description: "filters observer")
    exp.expectedFulfillmentCount = 7
    group.$filters
      .sink { _ in
        exp.fulfill()
      }.store(in: &cancellables)
    let priceFilter = FacetFilter(attribute: "price", value: 99.90)
    let availableFilter = FacetFilter(attribute: "isAvailable", value: true)
    let colorFilter = FacetFilter(attribute: "color", value: "red")
    group.add(priceFilter)
    group.add(availableFilter)
    group.add(colorFilter)
    XCTAssertEqual(group.description, """
    ( "color":"red" OR "isAvailable":"true" OR "price":"99.9" )
    """)
    XCTAssertEqual(group.filters(withAttribute: "isAvailable") as? [FacetFilter], [availableFilter])
    XCTAssertEqual(group.filters(withAttribute: "price") as? [FacetFilter], [priceFilter])
    XCTAssertEqual(group.filters(withAttribute: "color") as? [FacetFilter], [colorFilter])
    group.remove(availableFilter)
    XCTAssertEqual(group.filters.count, 2)
    group.removeFilters(withAttribute: "price")
    XCTAssertEqual(group.filters.count, 1)
    group.removeAll()
    XCTAssertTrue(group.isEmpty)
    XCTAssertEqual(group.description, "")
    wait(for: [exp], timeout: 1)
  }

  func testFilters() {
    let filters = Filters()

    let exp = expectation(description: "exp")
    exp.expectedFulfillmentCount = 3

    filters
      .$groups
      .sink { _ in
        exp.fulfill()
      }
      .store(in: &cancellables)

    let andGroup = AndFilterGroup()
    filters.add(group: andGroup, forName: "myGroup")

    let group = filters.groups["myGroup"]

    guard let andGroup = group as? AndFilterGroup else {
      XCTFail("Unexpected not and group name")
      return
    }

    let andGroupExpectation = expectation(description: "and group")
    andGroupExpectation.expectedFulfillmentCount = 3

    andGroup
      .$filters
      .dropFirst()
      .sink { _ in
        andGroupExpectation.fulfill()
      }
      .store(in: &cancellables)

    andGroup.add("someTag" as TagFilter)
    andGroup.add(FacetFilter(attribute: "size", floatValue: 36))
    andGroup.add(NumericFilter(attribute: "price", range: 1 ... 10))

    let orGroup = OrFilterGroup<FacetFilter>()
    filters.add(group: orGroup, forName: "anotherGroup")

    let orGroupExpectation = expectation(description: "and group")
    orGroupExpectation.expectedFulfillmentCount = 3

    orGroup
      .$filters
      .dropFirst()
      .sink { _ in
        orGroupExpectation.fulfill()
      }
      .store(in: &cancellables)

    orGroup.add(FacetFilter(attribute: "price", value: 99.90))
    orGroup.add(FacetFilter(attribute: "isAvailable", value: true))
    orGroup.add(FacetFilter(attribute: "color", value: "red"))

    // swiftlint:disable line_length
    XCTAssertEqual(filters.description, """
    ( "_tags":"someTag" AND "price":1.0 TO 10.0 AND "size":"36.0" ) AND ( "color":"red" OR "isAvailable":"true" OR "price":"99.9" )
    """)
    // swiftlint:enable line_length
    wait(for: [exp, andGroupExpectation, orGroupExpectation], timeout: 1)
  }
}
