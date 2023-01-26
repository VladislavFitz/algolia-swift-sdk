import Foundation

public protocol StringOption: Codable, Equatable, RawRepresentable where RawValue == String {}

public extension StringOption {
  init(rawValue: RawValue) {
    self.init(rawValue: rawValue)!
  }
}

public extension ExpressibleByStringInterpolation where Self: StringOption {
  init(stringLiteral value: String) {
    self = .init(rawValue: value)
  }
}
