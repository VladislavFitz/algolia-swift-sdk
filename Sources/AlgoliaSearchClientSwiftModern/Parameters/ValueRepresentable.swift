import Foundation
public protocol ValueRepresentable {
  associatedtype Value
  var value: Value { get }
  init(_ value: Value)
}

public extension ValueRepresentable where Self: Encodable, Value: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

public extension ValueRepresentable where Self: URLEncodable, Value: URLEncodable {
  var urlEncodedString: String {
    return value.urlEncodedString
  }
}
