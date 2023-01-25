@testable import AlgoliaFoundation
import Foundation

struct StructA: Codable {
  let fieldA: String
}

struct StructB: Codable {
  let fieldB: String
}

func testEitherEncoding() throws {
  let value: Either<StructA, StructB> = .from(StructA(fieldA: "valueA"))

  let encoder = JSONEncoder()
  let decoder = JSONDecoder()
  let data = try encoder.encode(value)
  let json = try decoder.decode(JSON.self, from: data)
  print(json)
}
