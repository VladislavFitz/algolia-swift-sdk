import Foundation

public struct RequestTypeSupport: OptionSet {
  public let rawValue: Int
  public static let read = RequestTypeSupport(rawValue: 1 << 0)
  public static let write = RequestTypeSupport(rawValue: 1 << 1)
  public static let universal: RequestTypeSupport = [.read, .write]
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}

extension RequestTypeSupport: CustomStringConvertible {
  public var description: String {
    if contains(.universal) {
      return "universal"
    }
    if contains(.read) {
      return "read"
    }
    if contains(.write) {
      return "write"
    }
    return "none"
  }
}
