import AlgoliaFoundation
import Foundation

public struct AroundPrecisionFromDistance: Codable, Hashable {
  public let from: Int
  public let value: Int

  public init(from: Int, value: Int) {
    self.from = from
    self.value = value
  }

  static func from(_ from: Int, value: Int) -> Self {
    return Self(from: from, value: value)
  }
}

extension AroundPrecisionFromDistance: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    from = 0
    self.value = value
  }
}

extension AroundPrecisionFromDistance: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    from = 0
    self.value = Int(value)
  }
}

extension AroundPrecisionFromDistance: URLEncodable {
  public var urlEncodedString: String {
    return "{\"from\":\(from),\"value\":\(value)}"
  }
}
