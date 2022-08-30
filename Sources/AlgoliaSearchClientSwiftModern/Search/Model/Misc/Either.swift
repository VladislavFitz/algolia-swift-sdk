//
//  Either.swift
//
//
//  Created by Vladislav Fitc on 29.08.2022.
//

import Foundation

public enum Either<A, B> {
  case first(A)
  case second(B)

  public init(_ value: A) {
    self = .first(value)
  }

  public init(_ value: B) {
    self = .second(value)
  }

  public static func from(_ value: A) -> Self {
    .first(value)
  }

  public static func from(_ value: B) -> Self {
    .second(value)
  }

  public var first: A? {
    if case let .first(value) = self {
      return value
    } else {
      return nil
    }
  }

  public var second: B? {
    if case let .second(value) = self {
      return value
    } else {
      return nil
    }
  }
}

extension Either: Equatable where A: Equatable, B: Equatable {}

extension Either: Encodable where A: Encodable, B: Encodable {
  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .first(value):
      try value.encode(to: encoder)
    case let .second(value):
      try value.encode(to: encoder)
    }
  }
}

extension Either: Decodable where A: Decodable, B: Decodable {
  public init(from decoder: Decoder) throws {
    let firstDecodingError: Error
    do {
      self = .first(try A(from: decoder))
      return
    } catch {
      firstDecodingError = error
    }

    let secondDecodingError: Error
    do {
      self = .second(try B(from: decoder))
      return
    } catch {
      secondDecodingError = error
    }

    let compositeError = CompositeError.from(firstDecodingError, secondDecodingError)
    throw Swift.DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                  debugDescription: "Failed to decode both expected values",
                                                  underlyingError: compositeError))
  }
}

extension Either: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .first(value):
      return "\(value)"
    case let .second(value):
      return "\(value)"
    }
  }
}
