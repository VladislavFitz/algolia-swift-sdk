import AlgoliaFoundation
import Foundation

public extension Event {
  enum Payload: Equatable {
    case objectIDs([ObjectID])
    case filters([String])
    case objectIDsWithPositions([(ObjectID, Int)])

    public static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case let (.objectIDs(lValue), .objectIDs(rValue)):
        return lValue == rValue
      case let (.filters(lValue), .filters(rValue)):
        return lValue == rValue
      case let (.objectIDsWithPositions(lValue), .objectIDsWithPositions(rValue)):
        return lValue.map { $0.0 } == rValue.map { $0.0 } && lValue.map { $0.1 } == rValue.map { $0.1 }
      default:
        return false
      }
    }
  }
}

extension Event.Payload: Codable {
  enum CodingKeys: String, CodingKey {
    case objectIDs
    case filters
    case positions
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let objectIDsDecodingError: Error
    let filtersDecodingError: Error

    do {
      let objectIDs = try container.decode([ObjectID].self, forKey: .objectIDs)
      if let positions = try? container.decode([Int].self, forKey: .positions) {
        self = .objectIDsWithPositions(zip(objectIDs, positions).map { $0 })
      } else {
        self = .objectIDs(objectIDs)
      }
      return
    } catch {
      objectIDsDecodingError = error
    }

    do {
      let filters = try container.decode([String].self, forKey: .filters)
      self = .filters(filters)
      return
    } catch {
      filtersDecodingError = error
    }

    let compositeError = CompositeError.from(objectIDsDecodingError, filtersDecodingError)
    typealias Keys = Event.Payload.CodingKeys
    let debugDescription = "Neither \(Keys.filters.rawValue), nor \(Keys.objectIDs.rawValue) key found on decoder"
    let context = DecodingError.Context(codingPath: decoder.codingPath,
                                        debugDescription: debugDescription,
                                        underlyingError: compositeError)
    throw DecodingError.dataCorrupted(context)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case let .filters(filters):
      try container.encode(filters, forKey: .filters)

    case let .objectIDsWithPositions(objectIDswithPositions):
      try container.encode(objectIDswithPositions.map { $0.0 }, forKey: .objectIDs)
      try container.encode(objectIDswithPositions.map { $0.1 }, forKey: .positions)

    case let .objectIDs(objectsIDs):
      try container.encode(objectsIDs, forKey: .objectIDs)
    }
  }
}
