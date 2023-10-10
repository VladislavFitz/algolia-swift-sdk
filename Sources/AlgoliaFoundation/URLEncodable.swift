import Foundation

public protocol URLEncodable {
  var urlEncodedString: String { get }
}

public extension RawRepresentable where Self: URLEncodable, RawValue: URLEncodable {
  var urlEncodedString: String {
    rawValue.urlEncodedString
  }
}

extension String: URLEncodable {
  public var urlEncodedString: String {
    self
  }
}

extension Bool: URLEncodable {
  public var urlEncodedString: String {
    String(self)
  }
}

extension Int: URLEncodable {
  public var urlEncodedString: String {
    String(self)
  }
}

extension UInt: URLEncodable {
  public var urlEncodedString: String {
    String(self)
  }
}

extension Double: URLEncodable {
  public var urlEncodedString: String {
    String(self)
  }
}

extension Array: URLEncodable where Element: URLEncodable {
  public var urlEncodedString: String {
    map(\.urlEncodedString).joined(separator: ",").wrappedInBrackets()
  }
}
