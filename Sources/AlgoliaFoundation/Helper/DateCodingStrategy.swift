import Foundation

struct ClientDateCodingStrategy {
  private static let acceptedFormats = [
    "yyyy-MM-dd'T'HH:mm:ssZ",
    "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  ]

  static func decoding(decoder: Decoder) throws -> Date {
    let container = try decoder.singleValueContainer()
    if let unixTimeStamp = try? container.decode(TimeInterval.self) {
      return Date(timeIntervalSince1970: unixTimeStamp)
    }
    let stringValue = try container.decode(String.self)
    let formatter = DateFormatter()
    for format in acceptedFormats {
      formatter.dateFormat = format
      if let date = formatter.date(from: stringValue) {
        return date
      }
    }
    throw DecodingError.dataCorruptedError(in: container,
                                           debugDescription: "Date string doesnt conform to iso8601 standart")
  }

  static let encoding: (Date, Encoder) throws -> Void = { date, encoder in
    var container = encoder.singleValueContainer()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let dateString = formatter.string(from: date)
    try container.encode(dateString)
  }
}

public extension JSONDecoder.DateDecodingStrategy {
  static let algoliaClientDateDecodingStrategy = JSONDecoder.DateDecodingStrategy
    .custom(ClientDateCodingStrategy.decoding)
}

public extension JSONEncoder.DateEncodingStrategy {
  static let algoliaClientDateEncodingStrategy = JSONEncoder.DateEncodingStrategy
    .custom(ClientDateCodingStrategy.encoding)
}
