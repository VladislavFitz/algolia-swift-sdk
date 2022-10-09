//
//  Index+Indexing.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public extension Index {
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
   Add a new record to an index.

   - Note: This method allows you to create records on your index by sending one or more objects.
   Each object contains a set of attributes and values, which represents a full record on an index.
   There is no limit to the number of objects that can be passed, but a size limit of 1 GB on the total request.
   For performance reasons, it is recommended to push batches of ~10 MB of payload.
   Batching records allows you to reduce the number of network calls required for multiple operations.
   But note that each indexed object counts as a single indexing operation.
   When adding large numbers of objects, or large sizes, be aware of our rate limit.
   You’ll know you’ve reached the rate limit when you start receiving errors on your indexing operations.
   This can only be resolved if you wait before sending any further indexing operations.
   - Parameter object: The record of type T to save.
   - Parameter autoGeneratingObjectID: Add objectID if record type doesn't provide it in serialized form.
   - Returns: Object creation task
   */
  func saveObject<T: Encodable>(_ object: T, autoGeneratingObjectID: Bool = false) async throws -> ObjectCreation {
    if !autoGeneratingObjectID {
      ObjectIDChecker.assertObjectID(object)
    }
    let body = try client.jsonEncoder.encode(object)
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/\(indexName.rawValue)/query",
                                                          headers: ["Content-Type": "application/json"],
                                                          body: body,
                                                          requestType: .write)
    var objectCreation = try client.jsonDecoder.decode(ObjectCreation.self, from: responseData)
    objectCreation.index = self
    return objectCreation
  }

  /**
   Get one record using its ObjectID.

   - Parameter objectID: The ObjectID to identify the record.
   - Parameter attributesToRetrieve: Specify a list of Attribute to retrieve. This list will apply to all records.
     If you don’t specify any attributes, every attribute will be returned.
   - Returns: Decodable object of type T
   */

  func getObject<T: Decodable>(withID objectID: ObjectID, attributesToRetrieve: [Attribute] = []) async throws -> T {
    let attributesToRetrieveItem = URLQueryItem(
      name: "attributes",
      value: attributesToRetrieve.map(\.rawValue).joined(separator: ",")
    )
    let responseData = try await client.transport.perform(method: .get,
                                                          path: "/1/indexes/\(indexName.rawValue)/\(objectID.rawValue)",
                                                          queryItems: [attributesToRetrieveItem],
                                                          headers: [:],
                                                          body: nil,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(T.self, from: responseData)
  }

  /**
   Perform several indexing operations in one API call.
   - Parameter batchOperations: List of BatchOperation
   - Parameter batchSize: Size of chunk
   - Returns: Batches response task
   */
  @discardableResult func batch(_ batchOperations: [BatchOperation],
                                batchSize: Int? = .none) async throws -> BatchesResponse {
    let batchSize = batchSize ?? self.batchSize
    func singleBatch(operations _: [BatchOperation]) async throws -> BatchResponse {
      let responseData = try await client.transport.perform(method: .post,
                                                            path: "/1/indexes/\(indexName.rawValue)/batch",
                                                            headers: [:],
                                                            body: nil,
                                                            requestType: .write)
      return try client.jsonDecoder.decode(BatchResponse.self, from: responseData)
    }
    var responses: [BatchResponse] = []
    for operationsChunk in batchOperations.chunked(into: batchSize) {
      let response = try await singleBatch(operations: operationsChunk)
      responses.append(response)
    }
    return BatchesResponse(indexName: indexName, responses: responses)
  }

  /**
   Add multiple schemaless objects to an index.

   - See: saveObject
   - Parameter objects The list of records to save.
   - Parameter autoGeneratingObjectID: Add objectID if record type doesn't provide it in serialized form.
   - Returns: Batches response task
   */
  @discardableResult func saveObjects<T: Encodable>(_ objects: [T],
                                                    autoGeneratingObjectID: Bool = false)
    async throws -> BatchesResponse {
    try await batch(objects.map { .add($0, autoGeneratingObjectID: autoGeneratingObjectID) })
  }

  /**
   Replace multiple objects with an updated set of attributes.

   - See: replaceObject
   - Parameter replacements: The list of paris of ObjectID and the replacement object .
   - Returns: Batches response task
   */
  @discardableResult func replaceObjects<T: Encodable>(replacements: [(objectID: ObjectID, object: T)])
    async throws -> BatchesResponse {
    try await batch(replacements.map { .update(objectID: $0.objectID, $0.object) })
  }

  /**
   Remove multiple objects from an index using their ObjectID.
   - Parameter objectIDs: The list ObjectID to identify the records.
   - Returns: Batches response task
   */
  @discardableResult func deleteObjects(withIDs objectIDs: [ObjectID]) async throws -> BatchesResponse {
    try await batch(objectIDs.map { .delete(objectID: $0) })
  }

  /**
   Update one or more attributes of existing records.

   - Parameter updates: The list of pairs of ObjectID identifying the record and its PartialUpdate.
   - Parameter createIfNotExists: When true, a partial update on a nonexistent record will create the record
   (generating the objectID and using the attributes as defined in the record). When false, a partial
   update on a nonexistent record will be ignored (but no error will be sent back).
   - Returns: Batches response task
   */
  @discardableResult func partialUpdateObjects(updates: [(objectID: ObjectID, update: PartialUpdate)],
                                               createIfNotExists: Bool = true)
    async throws -> BatchesResponse {
    try await batch(updates.map { .partialUpdate(objectID: $0.objectID,
                                                 $0.update,
                                                 createIfNotExists: createIfNotExists) })
  }
}
