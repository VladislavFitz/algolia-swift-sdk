@testable import AlgoliaSearchClient
import XCTest

final class TestParameters: XCTestCase {
  func testCustomParameter() throws {
    let searchParameters = SearchParameters {
      CustomParameter(key: "someStringParameter", "someStringValue")
      CustomParameter(key: "someIntParameter", 1500)
    }
    try assertEncode(searchParameters, expected: [
      "someStringParameter": "someStringValue",
      "someIntParameter": 1500
    ])
    let settingsParameters = SettingsParameters {
      CustomParameter(key: "someStringParameter", "someStringValue")
      CustomParameter(key: "someIntParameter", 1500)
    }
    try assertEncode(settingsParameters, expected: [
      "someStringParameter": "someStringValue",
      "someIntParameter": 1500
    ])
  }

  func testAroundLatLng() throws {
    let parameters = SearchParameters {
      AroundLatLng(latitude: 10, longitude: 20)
    }
    try assertEncode(parameters, expected: ["aroundLatLng": "10.0,20.0"])
    XCTAssertEqual(parameters.urlEncodedString, "aroundLatLng=10.0,20.0")
  }

  func testAroundLatLngViaIP() throws {
    let parameters = SearchParameters {
      AroundLatLngViaIP(true)
    }
    try assertEncode(parameters, expected: ["aroundLatLngViaIP": true])
    XCTAssertEqual(parameters.urlEncodedString, "aroundLatLngViaIP=true")
  }

  func testAroundPrecision() throws {
    var parameters = SearchParameters {
      AroundPrecision(100)
    }
    try assertEncode(parameters, expected: ["aroundPrecision": 100])
    XCTAssertEqual(parameters.urlEncodedString, "aroundPrecision=100")

    parameters = SearchParameters {
      AroundPrecision(.from(10, value: 100), .from(500, value: 300))
    }
    try assertEncode(parameters, expected: [
      "aroundPrecision": [
        ["from": 10, "value": 100],
        ["from": 500, "value": 300]]
    ])
    XCTAssertEqual(parameters.urlEncodedString,
                   "aroundPrecision=%5B%7B" +
                   "%22from%22:10,%22value%22:100%7D,%7B" +
                   "%22from%22:500,%22value%22:300%7D%5D")

    parameters.aroundPrecision = .first(400)
    try assertEncode(parameters, expected: ["aroundPrecision": 400])
    XCTAssertEqual(parameters.urlEncodedString, "aroundPrecision=400")
  }

  func testAroundRadius() throws {
    var parameters = SearchParameters {
      AroundRadius(.all)
    }
    try assertEncode(parameters, expected: ["aroundRadius": "all"])
    XCTAssertEqual(parameters.urlEncodedString, "aroundRadius=all")

    parameters = SearchParameters {
      AroundRadius(.meters(300))
    }
    try assertEncode(parameters, expected: ["aroundRadius": 300])
    XCTAssertEqual(parameters.urlEncodedString, "aroundRadius=300")

    parameters = SearchParameters {
      AroundRadius(.custom("someValue"))
    }
    try assertEncode(parameters, expected: ["aroundRadius": "someValue"])
    XCTAssertEqual(parameters.urlEncodedString, "aroundRadius=someValue")

    parameters.aroundRadius = .all
    try assertEncode(parameters, expected: ["aroundRadius": "all"])
  }

  func testInsideBoundingBox() throws {
    var parameters = SearchParameters {
      InsideBoundingBox([
        BoundingBox(point1: Point(latitude: 10,
                                  longitude: 20),
                    point2: Point(latitude: 30,
                                  longitude: 40)),
        BoundingBox(point1: Point(latitude: 50,
                                  longitude: 60),
                    point2: Point(latitude: 70,
                                  longitude: 80))
      ])
    }
    try assertEncode(parameters, expected: ["insideBoundingBox": [
      [10, 20, 30, 40],
      [50, 60, 70, 80]
    ]])
    XCTAssertEqual(parameters.urlEncodedString,
                   "insideBoundingBox=%5B%5B10.0,20.0,30.0,40.0%5D,%5B50.0,60.0,70.0,80.0%5D%5D")
    parameters.insideBoundingBox = [
      BoundingBox(point1: Point(latitude: 20,
                                longitude: 30),
                  point2: Point(latitude: 40,
                                longitude: 50)),
      BoundingBox(point1: Point(latitude: 60,
                                longitude: 70),
                  point2: Point(latitude: 80,
                                longitude: 90))
    ]
    try assertEncode(parameters, expected: ["insideBoundingBox": [
      [20, 30, 40, 50],
      [60, 70, 80, 90]
    ]])
    XCTAssertEqual(parameters.urlEncodedString,
                   "insideBoundingBox=%5B%5B20.0,30.0,40.0,50.0%5D,%5B60.0,70.0,80.0,90.0%5D%5D")
  }

  func testInsidePolygon() throws {
    var parameters = SearchParameters {
      InsidePolygon(
        Polygon(
          Point(latitude: 1,
                longitude: 2),
          Point(latitude: 3,
                longitude: 4),
          Point(latitude: 5,
                longitude: 6)
        )
      )
    }
    try assertEncode(parameters, expected: ["insidePolygon": [
      1, 2, 3, 4, 5, 6
    ]])
    parameters.insidePolygon = Polygon(
      Point(latitude: 2, longitude: 3),
      Point(latitude: 4, longitude: 5),
      Point(latitude: 6, longitude: 7)
    )
    try assertEncode(parameters, expected: ["insidePolygon": [
      2, 3, 4, 5, 6, 7
    ]])
  }

  func testMinimumAroundRadius() throws {
    var parameters = SearchParameters {
      MinimumAroundRadius(100)
    }
    try assertEncode(parameters, expected: ["minimumAroundRadius": 100])
    parameters.minimumAroundRadius = 200
    try assertEncode(parameters, expected: ["minimumAroundRadius": 200])
  }
}
