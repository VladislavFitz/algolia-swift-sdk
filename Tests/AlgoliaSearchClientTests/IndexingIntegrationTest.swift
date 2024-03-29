//
//  IndexingIntegrationTest.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//
import AlgoliaFoundation
@testable import AlgoliaSearchClient
import Foundation
import TestHelper
import XCTest

extension SearchClient {
  convenience init(credentials: Credentials) {
    self.init(appID: credentials.applicationID,
              apiKey: credentials.apiKey)
  }
}

class IndexingIntegrationTests: XCTestCase {
  // swiftlint:disable function_body_length
  func testIndexing() async throws {
    let index = SearchClient(credentials: .primary).index(withName: "\(String.uniquePrefix)_\(name)")

    // Add 1 record with saveObject with an objectID and collect taskID/objectID
    let object = TestRecord.withGeneratedObjectID()
    let objectID = object.objectID!
    let objectCreation = try await index.saveObject(object)
    try await objectCreation.wait()
    XCTAssertEqual(objectCreation.objectID, objectID)

    // Add 1 record with saveObject without an objectID and collect taskID/objectID
    var objectWithGeneratedID = TestRecord()
    let objectWithGeneratedIDCreation = try await index.saveObject(objectWithGeneratedID, autoGeneratingObjectID: true)
    try await objectWithGeneratedIDCreation.wait()

    let generatedObjectID = objectWithGeneratedIDCreation.objectID
    objectWithGeneratedID.objectID = generatedObjectID

    // Perform a saveObjects with an empty set of objects and collect taskID
    let emptyObjectsCreation = try await index.saveObjects([JSON]())
    try await emptyObjectsCreation.wait()

    // Add 2 records with saveObjects with an objectID and collect taskID/objectID
    let objects = [TestRecord.withGeneratedObjectID(), TestRecord.withGeneratedObjectID()]
    let objectsIDs = objects.compactMap(\.objectID)
    let objectsCreation = try await index.saveObjects(objects)
    try await objectsCreation.wait()

    XCTAssertEqual(objectsCreation.objectIDs, objectsIDs)

    // Add 2 records with saveObjects without an objectID and collect taskID/objectID
    var objectsWithGeneratedID = [TestRecord(), TestRecord()]
    let objectsWithGeneratedIDCreation = try await index.saveObjects(objectsWithGeneratedID,
                                                                     autoGeneratingObjectID: true)
    try await objectWithGeneratedIDCreation.wait()

    let generatedObjectIDs = objectsWithGeneratedIDCreation.objectIDs.compactMap { $0 }
    objectsWithGeneratedID = zip(objectsWithGeneratedID, generatedObjectIDs).map { object, objectID in
      var objectCopy = object
      objectCopy.objectID = objectID
      return objectCopy
    }

    // Sequentially send 10 batches of 100 objects with objectID from 1 to 1000 with batch and collect taskIDs/objectIDs
    var batchRecords: [TestRecord] = []
    let chunkSize = 100
    let chunkCount = 10
    for startIndex in stride(from: 0, to: chunkSize * chunkCount, by: chunkSize) {
      let records = (startIndex ..< startIndex + chunkSize).map { TestRecord(objectID: "\($0)") }
      batchRecords.append(contentsOf: records)
      // Wait for all collected tasks to terminate with waitTask
      try await index.saveObjects(records).wait()
    }

    // Retrieve the 6 first records with getObject and check their content against original records
    // Retrieve the 1000 remaining records with getObjects with objectIDs from 1 to 1000 and
    // check their content against original records
    let firstObjectsIDs = ([objectID, generatedObjectID] + objectsIDs + generatedObjectIDs).compactMap { $0 }

    let expectedObjects = [object, objectWithGeneratedID] + objects + objectsWithGeneratedID
    let fetchedObjects: [TestRecord] = try await index.getObjects(withIDs: firstObjectsIDs).results.compactMap { $0 }

    for (expected, fetched) in zip(expectedObjects, fetchedObjects) {
      XCTAssertEqual(expected, fetched)
    }

    // Browse all records with browseObjects and make sure we have browsed 1006 records,
    // and check that all objectIDs are found
    var response = try await index.browse()

    var fetchedRecords: [TestRecord] = try response.hitsAsListOf(TestRecord.self)

    while let cursor = response.cursor {
      response = try await index.browse(cursor: cursor)
      fetchedRecords.append(contentsOf: try response.hitsAsListOf(TestRecord.self))
    }

    let expectedRecords = [object, objectWithGeneratedID] + objects + objectsWithGeneratedID + batchRecords

    XCTAssertEqual(Set(fetchedRecords), Set(expectedRecords))

    // Alter 1 record with partialUpdateObject and collect taskID/objectID
    try await index.partialUpdateObject(withID: objectID,
                                        with: .update(attribute: "string",
                                                      value: "partiallyUpdated"),
                                        createIfNotExists: false).wait()

    // Alter 2 records with partialUpdateObjects and collect taskID/objectID
    try await index.partialUpdateObjects(updates: [
      (objectsIDs[0], .update(attribute: "string",
                              value: "partiallyUpdated")),
      (objectsIDs[1], .increment(attribute: "numeric",
                                 value: 10))
    ],
    createIfNotExists: false).wait()

    // Wait for all collected tasks to terminate with waitTask
    // Retrieve all the previously altered records with getObject and check their content against the modified records
    let updated: [TestRecord] = try await index.getObjects(withIDs: [objectID] + objectsIDs).results.compactMap { $0 }

    var expectedObject = object
    expectedObject.string = "partiallyUpdated"
    XCTAssertEqual(updated.first { $0.objectID == objectID }, expectedObject)

    expectedObject = objects[0]
    expectedObject.string = "partiallyUpdated"
    XCTAssertEqual(updated.first { $0.objectID == objectsIDs[0] }, expectedObject)

    expectedObject = objects[1]
    expectedObject.numeric += 10
    XCTAssertEqual(updated.first { $0.objectID == objectsIDs[1] }, expectedObject)

    // Add 1 record with saveObject with an objectID and a tag algolia and wait for the task to finish
    let taggedRecord = TestRecord(objectID: "taggedObject", tags: ["algolia"])
    try await index.saveObject(taggedRecord).wait()

    // Delete the first record with deleteObject and collect taskID
    try await index.deleteObject(withID: objectID).wait()

    // Delete the record containing the tag algolia with deleteBy and the tagFilters option and collect taskID
    try await index.deleteObjects(byQuery: DeleteQueryParameters {
      Filters("algolia")
    }).wait()

    // Delete the 5 remaining first records with deleteObjects and collect taskID
    try await index.deleteObjects(withIDs: [generatedObjectID] + objectsIDs + generatedObjectIDs).wait()

    // Delete the 1000 remaining records with clearObjects and collect taskID
    // Wait for all collected tasks to terminate
    try await index.clearObjects().wait()

    // Browse all objects with browseObjects and make sure that no records are returned
    response = try await index.browse()
    XCTAssertEqual(response.nbHits, 0)

    try await index.delete().wait()
  }

  func testExists() async throws {
    let index = SearchClient(credentials: .primary).index(withName: "\(String.uniquePrefix)_\(name)")

    var indexExists = try await index.exists()
    XCTAssertFalse(indexExists)

    try await index.saveObject(TestRecord(objectID: "myObject")).wait()

    indexExists = try await index.exists()
    XCTAssertTrue(indexExists)

    try await index.delete().wait()
  }
}
