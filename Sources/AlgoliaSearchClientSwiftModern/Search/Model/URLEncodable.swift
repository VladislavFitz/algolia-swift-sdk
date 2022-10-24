//
//  URLEncodable.swift
//
//
//  Created by Vladislav Fitc on 29.08.2022.
//

import Foundation

public protocol URLEncodable {
  var urlEncodedString: String { get }
}

public extension RawRepresentable where Self: URLEncodable, RawValue: URLEncodable {
  var urlEncodedString: String {
    return rawValue.urlEncodedString
  }
}

extension String: URLEncodable {
  public var urlEncodedString: String {
    return self
  }
}

extension Bool: URLEncodable {
  public var urlEncodedString: String {
    return String(self)
  }
}

extension Int: URLEncodable {
  public var urlEncodedString: String {
    return String(self)
  }
}

extension UInt: URLEncodable {
  public var urlEncodedString: String {
    return String(self)
  }
}

extension Double: URLEncodable {
  public var urlEncodedString: String {
    return String(self)
  }
}
