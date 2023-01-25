import AlgoliaFoundation
import Foundation

public class Index {
  public let indexName: IndexName
  internal let client: Client

  internal let batchSize = 10000

  internal init(indexName: IndexName, client: Client) {
    self.indexName = indexName
    self.client = client
  }
}

public extension Index {
  /**
   Return whether an index exists or not

   - Returns: Bool value indicating if the index exists
   */
  @discardableResult func exists() async throws -> Bool {
    do {
      _ = try await getSettings()
      return true
    } catch let TransportError.nonRetryableError(error as HTTPError) where error.statusCode == .notFound {
      return false
    } catch {
      throw error
    }
  }

  /**
   Delete the index and all its settings, including links to its replicas.
   - Returns: Index deletion task
   */
  func delete() async throws -> IndexDeletion {
    let responseData = try await client.transport.perform(method: .delete,
                                                          path: "/1/indexes/\(indexName.rawValue)",
                                                          headers: [:],
                                                          body: nil,
                                                          requestType: .write)
    var indexDeletion = try client.jsonDecoder.decode(IndexDeletion.self, from: responseData)
    indexDeletion.index = self
    return indexDeletion
  }

  /**
   Make a copy of an index, including its objects, settings, synonyms, and query rules.

   - Note: This method enables you to copy the entire index (objects, settings, synonyms, and rules)
     OR one or more of the following index elements:
   - setting
   - synonyms
   - and rules (query rules)

   - Parameter scopes: Scopes set. If empty (.all alias), then all objects and all scopes are copied.
   - Parameter destination: IndexName of the destination Index.
   - Returns: IndexRevision  object
   */
  @discardableResult func copy(_ scopes: Scopes = .all,
                               to destination: IndexName) async throws -> IndexRevision {
    let operation = IndexOperation(operation: .copy(scopes),
                                   destination: destination)
    return try await perform(operation)
  }

  /**
   Rename an index. Normally used to reindex your data atomically, without any down time.
   The move index method is a safe and atomic way to rename an index.

   - Parameter destination: IndexName of the destination Index.
   - Returns: IndexRevision  object
   */
  @discardableResult func move(to destination: IndexName) async throws -> IndexRevision {
    let operation = IndexOperation(operation: .move,
                                   destination: destination)
    return try await perform(operation)
  }

  /**
   Perform index operation

   - Parameter operation: index operation to perform.
   - Returns: IndexRevision  object
   */
  internal func perform(_ operation: IndexOperation) async throws -> IndexRevision {
    let body = try client.jsonEncoder.encode(operation)
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/\(indexName.rawValue)/operation",
                                                          headers: [:],
                                                          body: body,
                                                          requestType: .write)
    var indexRevision = try client.jsonDecoder.decode(IndexRevision.self, from: responseData)
    indexRevision.index = self
    return indexRevision
  }
}
