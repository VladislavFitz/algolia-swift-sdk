@testable import Filters
import Foundation
import Combine
import XCTest

class FiltersTests: XCTestCase {
  
  var filtersSubscription: AnyCancellable?
  var andGroupSubscription: AnyCancellable?
  var orGroupSubscription: AnyCancellable?
  
  func testAndFilterGroup() {
    let group = AndFilterGroup()
    let exp = expectation(description: "filters observer")
    exp.expectedFulfillmentCount = 7
    andGroupSubscription = group.$filters.sink { group in
      exp.fulfill()
    }
    let tagFilter = "someTag" as TagFilter
    let facetFilter = FacetFilter(attribute: "size", value: 36)
    let numericFilter = NumericFilter(attribute: "price", range: 1...10)
    group.add(tagFilter)
    group.add(facetFilter)
    group.add(numericFilter)
    XCTAssertEqual(group.description, """
    ( "_tags":"someTag" AND "size":"36.0" AND "price":1.0 TO 10.0 )
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
    wait(for: [exp], timeout: 1)
  }
  
  func testOrFilterGroup() {
    let group = OrFilterGroup<FacetFilter>()
    let exp = expectation(description: "filters observer")
    exp.expectedFulfillmentCount = 7
    andGroupSubscription = group.$filters.sink { group in
      exp.fulfill()
    }
    let priceFilter = FacetFilter(attribute: "price", value: 99.90)
    let availableFilter = FacetFilter(attribute: "isAvailable", value: true)
    let colorFilter = FacetFilter(attribute: "color", value: "red")
    group.add(priceFilter)
    group.add(availableFilter)
    group.add(colorFilter)
    XCTAssertEqual(group.description, """
    ( "price":"99.9" OR "isAvailable":"true" OR "color":"red" )
    """)
    XCTAssertEqual(group.filters(withAttribute: "isAvailable"), [availableFilter])
    XCTAssertEqual(group.filters(withAttribute: "price"), [priceFilter])
    XCTAssertEqual(group.filters(withAttribute: "color"), [colorFilter])
    group.remove(availableFilter)
    group.removeFilters(withAttribute: "price")
    group.removeAll()
    XCTAssertTrue(group.isEmpty)
    wait(for: [exp], timeout: 1)
  }
  
  func testFilters() {
    let filters = Filters()
    
    let exp = expectation(description: "exp")
    exp.expectedFulfillmentCount = 3
    
    filtersSubscription = filters.$groups
      .sink { groups in
        exp.fulfill()
      }
    
    filters.groups["myGroup"] = AndFilterGroup()
    
    let group = filters.groups["myGroup"]
    
    guard let andGroup = group as? AndFilterGroup else {
      XCTFail("Unexpected not and group name")
      return
    }
    
    andGroup.add("someTag" as TagFilter)
    andGroup.add(FacetFilter(attribute: "size", floatValue: 36))
    andGroup.add(NumericFilter(attribute: "price", range: 1...10))
    
    let orGroup = OrFilterGroup<FacetFilter>()
    
    orGroupSubscription = orGroup.$filters.sink { group in
      print(group)
    }
    
    orGroup.add(FacetFilter(attribute: "price", value: 99.90))
    orGroup.add(FacetFilter(attribute: "isAvailable", value: true))
    orGroup.add(FacetFilter(attribute: "color", value: "red"))
    
    filters.groups["anotherGroup"] = orGroup
    
    wait(for: [exp], timeout: 1)
    
  }
  
}
