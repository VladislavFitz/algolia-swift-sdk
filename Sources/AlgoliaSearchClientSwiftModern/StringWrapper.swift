import Foundation

public protocol StringWrapper: RawRepresentable,
  ExpressibleByStringInterpolation,
  Codable,
  CustomStringConvertible,
  Hashable, URLEncodable where RawValue == String {
  init(rawValue: String)
}

public extension StringWrapper {
  init(stringLiteral value: String) {
    self.init(rawValue: value)
  }
}

public extension StringWrapper {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let intValue = try? container.decode(Int.self) {
      self.init(rawValue: "\(intValue)")
    } else {
      let rawValue = try container.decode(String.self)
      self.init(rawValue: rawValue)
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }
}

public extension StringWrapper {
  var description: String {
    return rawValue
  }
}

public extension StringWrapper {
  var urlEncodedString: String {
    return rawValue.urlEncodedString
  }
}
