//
//  SnippetsTest.swift
//
//
//  Created by Vladislav Fitc on 14.11.2022.
//

@testable import AlgoliaSearchClient
import Foundation
import XCTest

class SnippetsTest: XCTestCase {
  struct Contact: Codable {
    let firstname: String
    let lastname: String
    let followers: Int
    let company: String
  }

  func gettingStarted() async throws {
    let client = SearchClient(appID: "YourApplicationID", apiKey: "YourAdminAPIKey")
    let index = client.index(withName: "your_index_name")

    let contacts: [Contact] = [
      Contact(firstname: "Jimmie",
              lastname: "Barninger",
              followers: 93,
              company: "California Paint"),
      Contact(firstname: "Warren",
              lastname: "Speach",
              followers: 42,
              company: "Norwalk Crmc")
    ]

    let saveObjectsTask = try await index.saveObjects(contacts, autoGeneratingObjectID: true)
    try await saveObjectsTask.wait()

    let searchParameters = SearchParameters {
      Query("jimmie")
    }

    /** Creation of search parameters without result builder is supported
     var searchParameters = SearchParameters()
     searchParameters.query = "jimmie"
     */
    let searchResponse = try await index.search(parameters: searchParameters)

    let foundContacts = try searchResponse.hitsAsListOf(Contact.self)
    print("found contacts: \(foundContacts)")

    var settingsParameters = SettingsParameters {
      CustomRanking([.desc("followers")])
    }

    /** Creation of settings parameters without result builder is supported
     var settingsParameters = SettingsParameters()
     settingsParameters.customRanking = [.desc("followers")]
     */

    try await index.setSettings(settingsParameters)

    settingsParameters = SettingsParameters {
      SearchableAttributes(["lastname", "firstname", "company"])
    }

    try await index.setSettings(settingsParameters)
  }
}
