import Foundation

public struct HTTPError: Error, LocalizedError, CustomStringConvertible {
  public let statusCode: HTTPStatusСode
  public let message: ErrorMessage?

  public init?(response: HTTPURLResponse?, data: Data?) {
    guard let response = response, !response.statusCode.belongs(to: .success) else {
      return nil
    }

    let message = data.flatMap { try? JSONDecoder().decode(ErrorMessage.self, from: $0) }
    self.init(statusCode: response.statusCode, message: message)
  }

  public init(statusCode: HTTPStatusСode, message: ErrorMessage?) {
    self.statusCode = statusCode
    self.message = message
  }

  public var description: String {
    return "Status code: \(statusCode) Message: \(message.flatMap { $0.description } ?? "No message")"
  }

  public var errorDescription: String? {
    return "code: \(statusCode)" + (message.flatMap { " (\($0))" } ?? "")
  }
}

public struct ErrorMessage: Codable, CustomStringConvertible {
  enum CodingKeys: String, CodingKey {
    case description = "message"
  }

  public let description: String

  public init(description: String) {
    self.description = description
  }
}
