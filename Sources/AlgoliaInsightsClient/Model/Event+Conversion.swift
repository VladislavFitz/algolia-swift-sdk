import AlgoliaFoundation
import Foundation

public extension Event {
  static func conversion(name: Event.Name,
                         indexName: IndexName,
                         userToken: UserToken?,
                         timestamp: Date? = nil,
                         queryID: QueryID?,
                         objectIDs: [ObjectID]) throws -> Self {
    return try self.init(type: .conversion,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: queryID,
                         payload: .objectIDs(objectIDs))
  }

  static func conversion(name: Event.Name,
                         indexName: IndexName,
                         userToken: UserToken?,
                         timestamp: Date? = nil,
                         queryID: QueryID?,
                         filters: [String]) throws -> Self {
    return try self.init(type: .conversion,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: queryID,
                         payload: .filters(filters))
  }
}
