//
//  AttributeForFaceting.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

import Foundation

public enum AttributeForFaceting: Equatable, Codable {
  case `default`(Attribute)
  case filterOnly(Attribute)
  case searchable(Attribute)
}

extension AttributeForFaceting: ExpressibleByStringInterpolation {
  public init(stringLiteral value: String) {
    self = .default(.init(rawValue: value))
  }
}

extension AttributeForFaceting: RawRepresentable {
  private enum Prefix: String {
    case filterOnly
    case searchable
  }

  public var rawValue: String {
    switch self {
    case let .default(attribute):
      return attribute.rawValue
    case let .filterOnly(attribute):
      return PrefixedString(prefix: Prefix.filterOnly.rawValue, value: attribute.rawValue).description
    case let .searchable(attribute):
      return PrefixedString(prefix: Prefix.searchable.rawValue, value: attribute.rawValue).description
    }
  }

  public init(rawValue: String) {
    if
      let prefixedString = PrefixedString(rawValue: rawValue),
      let prefix = Prefix(rawValue: prefixedString.prefix) {
      switch prefix {
      case .filterOnly:
        self = .filterOnly(.init(rawValue: prefixedString.value))
      case .searchable:
        self = .searchable(.init(rawValue: prefixedString.value))
      }
    } else {
      self = .default(.init(rawValue: rawValue))
    }
  }
}
