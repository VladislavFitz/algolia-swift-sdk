import AlgoliaFoundation
import Foundation

public extension Event {
  static func click(name: Event.Name,
                    indexName: IndexName,
                    userToken: UserToken?,
                    timestamp: Date? = nil,
                    queryID: QueryID,
                    objectIDsWithPositions: [(ObjectID, Int)]) throws -> Self {
    return try self.init(type: .click,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: queryID,
                         payload: .objectIDsWithPositions(objectIDsWithPositions))
  }

  static func click(name: Event.Name,
                    indexName: IndexName,
                    userToken: UserToken?,
                    timestamp: Date? = nil,
                    objectIDs: [ObjectID]) throws -> Self {
    return try self.init(type: .click,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: .none,
                         payload: .objectIDs(objectIDs))
  }

  static func click(name: Event.Name,
                    indexName: IndexName,
                    userToken: UserToken?,
                    timestamp: Date? = nil,
                    filters: [String]) throws -> Self {
    return try self.init(type: .click,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: .none,
                         payload: .filters(filters))
  }
}
