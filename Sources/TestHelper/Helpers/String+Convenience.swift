import Foundation

public extension String {
  init(randomWithLength length: Int) {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    self = String((0 ..< length).compactMap { _ in letters.randomElement() })
  }

  static var random: String { .random(length: .random(in: 1 ... 30)) }
  static func random(length: Int) -> String { .init(randomWithLength: length) }
}

public extension String {
  static var uniquePrefix: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-DD_HH:mm:ss"
    let dateString = dateFormatter.string(from: .init())
    return "swift_\(dateString)_\(NSUserName().description)"
  }
}

public extension String {
  init?(environmentVariable: String) {
    if
      let rawValue = getenv(environmentVariable),
      let value = String(utf8String: rawValue) {
      self = value
    } else {
      return nil
    }
  }
}
