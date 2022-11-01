import Foundation

public extension Index {
  /**
   Perform several indexing operations in one API call.
   - Parameter batchOperations: List of BatchOperation
   - Parameter batchSize: Size of chunk
   - Returns: Batches response task
   */
  @discardableResult func batch(_ batchOperations: [BatchOperation],
                                batchSize: Int? = .none) async throws -> BatchesResponse {
    let batchSize = batchSize ?? self.batchSize
    func singleBatch(operations: [BatchOperation]) async throws -> BatchResponse {
      let body = try client.jsonEncoder.encode(FieldWrapper.requests(operations))
      let responseData = try await client.transport.perform(method: .post,
                                                            path: "/1/indexes/\(indexName.rawValue)/batch",
                                                            headers: [:],
                                                            body: body,
                                                            requestType: .write)
      var batchResponse = try client.jsonDecoder.decode(BatchResponse.self, from: responseData)
      batchResponse.index = self
      return batchResponse
    }
    var responses: [BatchResponse] = []
    for operationsChunk in batchOperations.chunked(into: batchSize) {
      let response = try await singleBatch(operations: operationsChunk)
      responses.append(response)
    }
    return BatchesResponse(indexName: indexName, responses: responses)
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
                                                          path: "/1/indexes/\(indexName.rawValue)",
                                                          headers: [:], // "Content-Type": "application/json"
                                                          body: body,
                                                          requestType: .write)
    var objectCreation = try client.jsonDecoder.decode(ObjectCreation.self, from: responseData)
    objectCreation.index = self
    return objectCreation
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
    Get multiple records using their ObjectID.

   - Parameter objectIDs: The list ObjectID to identify the records.
   - Parameter attributesToRetrieve: Specify a list of Attribute to retrieve.
     This list will apply to all records. If you don’t specify any attributes, every attribute will be returned.
   - Returns: ObjectResponse object containing requested records
   */
  func getObjects<T: Decodable>(withIDs objectIDs: [ObjectID],
                                attributesToRetreive: [Attribute]? = .none) async throws -> ObjectsResponse<T> {
    let objectRequests = objectIDs
      .map { ObjectRequest(indexName: indexName,
                           objectID: $0,
                           attributesToRetrieve: attributesToRetreive) }
    let requests = FieldWrapper.requests(objectRequests)
    let body = try client.jsonEncoder.encode(requests)
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/*/objects",
                                                          headers: [:],
                                                          body: body,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(ObjectsResponse<T>.self, from: responseData)
  }

  /**
   Replace an existing object with an updated set of attributes.
   - See_also: replaceObject
   - Parameter objectID: The ObjectID to identify the object.
   - Parameter record: The record T to replace.
   - Returns: ObjectRevision object
   */
  @discardableResult func replaceObject<T: Encodable>(withID objectID: ObjectID,
                                                      by object: T) async throws -> ObjectRevision {
    let body = try client.jsonEncoder.encode(object)
    let responseData = try await client.transport.perform(method: .put,
                                                          path: "/1/indexes/\(indexName.rawValue)/\(objectID.rawValue)",
                                                          headers: [:],
                                                          body: body,
                                                          requestType: .write)
    var objectRevision = try client.jsonDecoder.decode(ObjectRevision.self, from: responseData)
    objectRevision.index = self
    return objectRevision
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
    Remove an object from an index using its ObjectID.

    - Parameter objectID: The ObjectID to identify the record.
    - Returns: Requested record
   */
  @discardableResult func deleteObject(withID objectID: ObjectID) async throws -> ObjectDeletion {
    let responseData = try await client.transport.perform(method: .delete,
                                                          path: "/1/indexes/\(indexName.rawValue)/\(objectID.rawValue)",
                                                          headers: [:],
                                                          body: nil,
                                                          requestType: .write)
    var objectDeletion = try client.jsonDecoder.decode(ObjectDeletion.self, from: responseData)
    objectDeletion.index = self
    return objectDeletion
  }

  /**
    Remove all objects matching a DeleteByQuery.

   - Parameter query: parameters to match records for deletion.
   - Parameter requestOptions: Configure request locally with RequestOptions.
   - Returns: RevisionIndex object
   */
  @discardableResult func deleteObjects(byQuery query: DeleteQueryParameters) async throws -> IndexRevision {
    let body = try client.jsonEncoder.encode(FieldWrapper.params(query.urlEncodedString))
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/\(indexName.rawValue)/deleteByQuery",
                                                          headers: [:],
                                                          body: body,
                                                          requestType: .write)
    var indexRevision = try client.jsonDecoder.decode(IndexRevision.self, from: responseData)
    indexRevision.index = self
    return indexRevision
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
   Update one or more attributes of an existing record.

   - Parameter objectID: The ObjectID identifying the record to partially update.
   - Parameter partialUpdate: PartialUpdate
   - Parameter createIfNotExists: When true, a partial update on a nonexistent record will create the record
   (generating the objectID and using the attributes as defined in the record). When false, a partial
   update on a nonexistent record will be ignored (but no error will be sent back).
   - Returns: ObjectRevision object
   */
  @discardableResult func partialUpdateObject(withID objectID: ObjectID,
                                              with partialUpdate: PartialUpdate,
                                              createIfNotExists: Bool = true) async throws -> ObjectRevision {
    let body = try client.jsonEncoder.encode(partialUpdate)
    let path = "/1/indexes/\(indexName.rawValue)/\(objectID.rawValue)/partial"
    let queryItems = [
      URLQueryItem(name: "createIfNotExists",
                   value: String(createIfNotExists))
    ]
    let responseData = try await client.transport.perform(method: .post,
                                                          path: path,
                                                          queryItems: queryItems,
                                                          headers: [:],
                                                          body: body,
                                                          requestType: .write)
    var objectRevision = try client.jsonDecoder.decode(ObjectRevision.self, from: responseData)
    objectRevision.index = self
    return objectRevision
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

  /**
   Clear the records of an index without affecting its settings.

   - Returns: RevisionIndex object
   */
  @discardableResult func clearObjects() async throws -> IndexRevision {
    let responseData = try await client.transport.perform(method: .post,
                                                          path: "/1/indexes/\(indexName.rawValue)/clear",
                                                          headers: [:],
                                                          body: nil,
                                                          requestType: .write)
    var indexRevision = try client.jsonDecoder.decode(IndexRevision.self, from: responseData)
    indexRevision.index = self
    return indexRevision
  }

  /**
   Push a new set of objects and remove all previous ones. Settings, synonyms and query rules are untouched.
   Replace all objects in an index without any downtime.
   Internally, this method copies the existing index settings, synonyms and query rules and indexes all
   passed objects. Finally, the existing index is replaced by the temporary one.

   - Returns: [IndexedTask]  object
   */
  @discardableResult func replaceAllObjects<T: Encodable>(with objects: [T],
                                                          autoGeneratingObjectID: Bool = false)
    async throws -> [IndexedTask] {
    let moveOperations: [BatchOperation] = objects.map { .add($0, autoGeneratingObjectID: autoGeneratingObjectID) }
    let destinationIndexName = IndexName(rawValue: "\(indexName)_tmp_\(Int.random(in: 0 ... 100_000))")
    let destinationIndex = Index(indexName: destinationIndexName, client: client)
    let moveTasks = try await destinationIndex.batch(moveOperations).tasks
    let copyTaskID = try await copy([.settings, .rules, .synonyms], to: destinationIndexName).taskID
    let moveTaskID = try await destinationIndex.move(to: indexName).taskID
    return [
      IndexedTask(indexName: indexName, taskID: copyTaskID),
      IndexedTask(indexName: destinationIndexName, taskID: moveTaskID)
    ] + moveTasks
  }
}
