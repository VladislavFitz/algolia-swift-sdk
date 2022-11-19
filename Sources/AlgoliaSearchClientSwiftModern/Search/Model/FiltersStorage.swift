// swiftlint:disable identifier_name
import Foundation

public struct FiltersStorage: Equatable {
  public var units: [Unit]

  public init(units: [Unit]) {
    self.units = units
  }

  public enum Unit: Equatable {
    case and([String])
    case or([String])
  }

  public static func and(_ units: Unit...) -> Self {
    .init(units: units)
  }
}

public extension FiltersStorage.Unit {
  static func and(_ filters: String...) -> Self {
    .and(filters)
  }

  static func or(_ filters: String...) -> Self {
    .or(filters)
  }
}

extension FiltersStorage: RawRepresentable {
  public var rawValue: [SingleOrList<String>] {
    var output: [SingleOrList<String>] = []
    for unit in units {
      switch unit {
      case let .and(values):
        output.append(contentsOf: values.map { SingleOrList.first($0) })
      case let .or(values):
        output.append(.list(values))
      }
    }
    return output
  }

  public init(rawValue: [SingleOrList<String>]) {
    var units: [Unit] = []
    for element in rawValue {
      switch element {
      case let .first(value):
        units.append(.and([value]))
      case let .second(values):
        units.append(.or(values))
      }
    }
    self.init(units: units)
  }
}

extension FiltersStorage: Codable {
  public init(from decoder: Decoder) throws {
    self.init(rawValue: try RawValue(from: decoder))
  }

  public func encode(to encoder: Encoder) throws {
    try rawValue.encode(to: encoder)
  }
}

extension FiltersStorage.Unit: ExpressibleByStringInterpolation {
  public init(stringLiteral value: String) {
    self = .and([value])
  }
}

extension FiltersStorage: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Unit...) {
    self.init(units: elements)
  }
}

extension FiltersStorage: URLEncodable {
  public var urlEncodedString: String {
    func toString(_ singleOrList: SingleOrList<String>) -> String {
      switch singleOrList {
      case let .first(value):
        return value.wrappedInQuotes()
      case let .second(list):
        return list.map { $0.wrappedInQuotes() }.joined(separator: ",").wrappedInBrackets()
      }
    }
    return rawValue.map(toString).joined(separator: ",").wrappedInBrackets()
  }
}

extension String {
  func wrappedInQuotes() -> String { "\"\(self)\"" }
  func wrappedInBrackets() -> String { "[\(self)]" }
}
