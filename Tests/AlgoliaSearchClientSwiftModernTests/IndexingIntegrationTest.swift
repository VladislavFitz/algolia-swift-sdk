//
//  IndexingIntegrationTest.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//
@testable import AlgoliaSearchClientSwiftModern
import Foundation
import XCTest

class IndexingIntegrationTests: XCTestCase {
  func uniquePrefix() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-DD_HH:mm:ss"
    let dateString = dateFormatter.string(from: .init())
    return "swift_\(dateString)_\(NSUserName().description)"
  }

  func testIndexing() async throws {
    let index = Client(credentials: .primary).index(withName: "\(uniquePrefix())_\(name)")

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
    let objectsIDs = objects.map(\.objectID)
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
    let firstObjectsIDs = [objectID, generatedObjectID] + objectsIDs + generatedObjectIDs

    try await index.delete().wait()
  }
}
