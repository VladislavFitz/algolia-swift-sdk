import AlgoliaFoundation
import Foundation

public struct Event {
  public let type: `Type`
  public let name: Name
  public let indexName: IndexName
  public let userToken: UserToken?
  public let timestamp: Int64?
  public let queryID: QueryID?
  public let payload: Payload

  init(type: Type,
       name: Name,
       indexName: IndexName,
       userToken: UserToken?,
       timestamp: Int64?,
       queryID: QueryID?,
       payload: Payload) throws {
    try Event.checkEventName(name)
    try Event.check(payload)

    self.type = type
    self.name = name
    self.indexName = indexName
    self.userToken = userToken
    self.timestamp = timestamp
    self.queryID = queryID
    self.payload = payload
  }

  init(type: Type,
       name: Name,
       indexName: IndexName,
       userToken: UserToken?,
       timestamp: Date?,
       queryID: QueryID?,
       payload: Payload) throws {
    let rawTimestamp = timestamp?.timeIntervalSince1970.milliseconds
    try self.init(type: type,
                  name: name,
                  indexName: indexName,
                  userToken: userToken,
                  timestamp: rawTimestamp,
                  queryID: queryID,
                  payload: payload)
  }
}

private extension Event {
  static func checkEventName(_ eventName: Event.Name) throws {
    if eventName.rawValue.isEmpty {
      throw ConstructionError.emptyEventName
    }
  }

  static func check(_ resources: Event.Payload) throws {
    switch resources {
    case let .filters(filters) where filters.count > Constraint.maxFiltersCount:
      throw ConstructionError.filtersCountOverflow

    case let .objectIDs(objectIDs) where objectIDs.count > Constraint.maxObjectIDsCount:
      throw ConstructionError.objectIDsCountOverflow

    default:
      break
    }
  }
}

extension Event: Codable {
  enum CodingKeys: String, CodingKey, CaseIterable {
    case type = "eventType"
    case name = "eventName"
    case indexName = "index"
    case userToken
    case timestamp
    case queryID
    case positions
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    type = try container.decode(Type.self, forKey: .type)
    name = try container.decode(Name.self, forKey: .name)
    indexName = try container.decode(IndexName.self, forKey: .indexName)
    userToken = try container.decodeIfPresent(UserToken.self, forKey: .userToken)
    timestamp = try container.decodeIfPresent(Int64.self, forKey: .timestamp)
    queryID = try container.decodeIfPresent(QueryID.self, forKey: .queryID)
    payload = try Payload(from: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(type, forKey: .type)
    try container.encode(name, forKey: .name)
    try container.encode(indexName, forKey: .indexName)
    try container.encodeIfPresent(userToken, forKey: .userToken)
    try container.encodeIfPresent(timestamp, forKey: .timestamp)
    try container.encodeIfPresent(queryID, forKey: .queryID)
    try payload.encode(to: encoder)
  }
}

public extension Event {
  struct Name: StringOption {
    public let rawValue: String

    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }
}

public extension Event {
  struct `Type`: StringOption {
    public static var click: Self { .init(rawValue: #function) }
    public static var view: Self { .init(rawValue: #function) }
    public static var conversion: Self { .init(rawValue: #function) }

    public let rawValue: String

    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }
}
