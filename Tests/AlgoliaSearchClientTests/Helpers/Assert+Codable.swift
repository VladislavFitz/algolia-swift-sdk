@testable import AlgoliaSearchClient
import AlgoliaFoundation
import Foundation
import XCTest

func assertEncode<T: Encodable>(_ value: T,
                                expected: JSON,
                                file: StaticString = #file,
                                line: UInt = #line) throws {
  let encoder = JSONEncoder()
  encoder.dateEncodingStrategy = .algoliaClientDateEncodingStrategy
  let valueData = try encoder.encode(value)

  let jsonDecoder = JSONDecoder()
  jsonDecoder.dateDecodingStrategy = .algoliaClientDateDecodingStrategy
  let jsonFromValue = try jsonDecoder.decode(JSON.self, from: valueData)

  XCTAssertEqual(jsonFromValue, expected, file: file, line: line)
}

func assertDecode<T: Codable>(_ input: JSON,
                              expected: T,
                              file: StaticString = #file,
                              line: UInt = #line) throws {
  let encoder = JSONEncoder()
  encoder.dateEncodingStrategy = .algoliaClientDateEncodingStrategy
  let data = try encoder.encode(input)

  let jsonDecoder = JSONDecoder()
  jsonDecoder.dateDecodingStrategy = .algoliaClientDateDecodingStrategy
  let decoded = try jsonDecoder.decode(T.self, from: data)

  let decodedJSON = try JSON(decoded)
  let expectedJSON = try JSON(expected)

  XCTAssertEqual(expectedJSON, decodedJSON, file: file, line: line)
}

func assertEncodeDecode<T: Codable>(_ value: T,
                                    _ rawValue: JSON,
                                    file: StaticString = #file,
                                    line: UInt = #line) throws {
  try assertEncode(value, expected: rawValue, file: file, line: line)
  try assertDecode(rawValue, expected: value, file: file, line: line)
}
