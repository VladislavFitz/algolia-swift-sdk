import AlgoliaFoundation
import Foundation

public extension Event {
  static func view(name: Event.Name,
                   indexName: IndexName,
                   userToken: UserToken?,
                   timestamp: Date? = nil,
                   objectIDs: [ObjectID]) throws -> Self {
    return try self.init(type: .view,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: nil,
                         payload: .objectIDs(objectIDs))
  }

  static func view(name: Event.Name,
                   indexName: IndexName,
                   userToken: UserToken?,
                   timestamp: Date? = nil,
                   filters: [String]) throws -> Self {
    return try self.init(type: .view,
                         name: name,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp,
                         queryID: nil,
                         payload: .filters(filters))
  }
}
