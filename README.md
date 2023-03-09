[![swift](https://img.shields.io/badge/Swift-5.6-orange)](https://www.swift.org)
[![test](https://github.com/VladislavFitz/algolia-swift-sdk/actions/workflows/test.yml/badge.svg)](https://github.com/VladislavFitz/algolia-swift-sdk/actions/workflows/test.yml)
![platform](https://img.shields.io/badge/platforms-iOS_13+%20%7C%20macOS_10.15+%20%7C%20tvOS_13+%20%7C%20watchOS_6+-blue.svg?style=flat")
[![MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Algolia Swift SDK

Unofficial Algolia Swift SDK built by Algolia employee.
Adopts the latest Swift features and provides the best developer experience.

- Pure Swift SDK
- Implements Algolia retry strategy and official Algolia API client test suite
- All the methods use the modern Swift concurrency methods (async/await)
- Convenient `wait()` methods for asynchronous backend tasks
- Uses the result builder for search and settings parameters
- Supports search, indexing and Insights events capture methods

## Install

### Swift Package Manager

The Swift Package Manager is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.
Since the release of Swift 5 and Xcode 11, SPM is compatible with the iOS,
macOS and tvOS build systems for creating apps.

To use SwiftPM, you should use Xcode 11 to open your project. Click `File` -> `Swift Packages`
-> `Add Package Dependency`, enter `github.com/VladislavFitz/algolia-swift-sdk`

If you're a framework author and use Swift API Client as a dependency, update your `Package.swift` file:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/VladislavFitz/algolia-swift-sdk", from: "0.3.0")
    ],
    // ...
)
```

## Products

- [Search client](/Sources/AlgoliaSearchClient) - client for search and indexing requests
- [Insights client](/Sources/AlgoliaInsightsClient) - client for the [Insights API](https://www.algolia.com/doc/api-client/methods/insights/) which lets you capture click, conversion, and view events to help you understand how your users interact with your digital experience.
- [Filters](Sources/AlgoliaFilters) - component which provides a user-friendly interface for managing filters

## Getting started

### Initialize the client

To start, you need to initialize the client. To do this, you need your **Application ID** and **API Key**.
You can find both on [your Algolia account](https://www.algolia.com/api-keys).

```swift
let client = SearchClient(appID: "YourApplicationID", apiKey: "YourAdminAPIKey")
let index = client.index(withName: "your_index_name")
```

### Push data

Without any prior configuration, you can start indexing contacts in the `contacts` index using the following code:

```swift
struct Contact: Codable {
  let firstname: String
  let lastname: String
  let followers: Int
  let company: String
}

let contacts: [Contact] = [
  Contact(firstname: "Jimmie",
          lastname: "Barninger",
          followers: 93,
          company: "California Paint"),
  Contact(firstname: "Warren",
          lastname: "Speach",
          followers: 42,
          company: "Norwalk Crmc"),
]

let index = client.index(withName: "contacts")
let saveObjectsTask = try await index.saveObjects(contacts, autoGeneratingObjectID: true)
try await saveObjectsTask.wait()
```

### Search

You can now search for contacts by `firstname`, `lastname`, `company`, etc. (even with typos):

```swift
let searchParameters = SearchParameters {
  Query("jimmie")
}

/** SearchParameters can also be created as a classic structure
var searchParameters = SearchParameters()
searchParameters.query = "jimmie"
*/

let searchResponse = try await index.search(parameters: searchParameters)

let foundContacts = try searchResponse.hitsAsListOf(Contact.self)
print("found contacts: \(foundContacts)")
```

### Configure

Settings can be customized to tune the search behavior.
For example, you can add a custom sort by number of followers to the already great built-in relevance:

```swift
var settingsParameters = SettingsParameters {
  CustomRanking([.desc("followers")])
}
    
/** SettingsParameters can also be created as a classic structure
var settingsParameters = SettingsParameters()
settingsParameters.customRanking = [.desc("followers")]
*/

try await index.setSettings(settingsParameters)
```

You can also configure the list of attributes you want to index by order of importance (first = most important):

**Note:** Since the engine is designed to suggest results as you type, you'll generally search by prefix.
In this case the order of attributes is very important to decide which hit is the best:

```swift
settingsParameters = SettingsParameters {
  SearchableAttributes(["lastname", "firstname", "company"])
}

try await index.setSettings(settingsParameters)
```

### Insights

Insights client allows developers to capture search-related events. The events maybe related to search queries (such as click an conversion events used for Click Analytics or A/B testing). 
It does so by correlating events with queryIDs generated by the search API when a query parameter `clickAnalytics` is set to true. 
As well library allows to capture search-independent events which can be used for the purpose of search experience personalization. 
There are three types of these events which are currently supported: `click`, `conversion` and `view`.

```swift
let insightsClient = InsightsClient(appID: "YourApplicationID", apiKey: "YourAPIKey")

let events: [Event] = [
  try .click(name: "foo",
             indexName: index.name,
             userToken: "bar",
             timestamp: timestamp,
             objectIDs: ["one", "two"]),
  try .click(name: "foo",
             indexName: index.name,
             userToken: "bar",
             timestamp: timestamp,
             objectIDs: ["one", "two"])
]
try await insightsClient.send(events)


let searchParameters = SearchParameters(ClickAnalytics(true))
let searchResponse = try await index.search(parameters: searchParameters)
let queryID = searchResponse.queryID

let eventsAfterSearch = [
  try Event.view(name: "foo",
                 indexName: index.name,
                 userToken: "bar",
                 objectIDs: ["one", "two"]),
  try Event.click(name: "foo",
                  indexName: index.name,
                  userToken: "bar",
                  queryID: queryID!,
                  objectIDsWithPositions: [("one", 1), ("two", 2)]),
  try Event.conversion(name: "foo",
                       indexName: index.name,
                       userToken: "bar",
                       queryID: queryID!,
                       objectIDs: ["one", "two"]),
]

try await insightsClient.send(eventsAfterSearch)
```


## Available methods

### Search client

- List indices
- Search (multi-index)

### Index

- Exists
- Delete
- Copy
- Move

### Index + Objects

- Batch objects operations
- Save object(s)
- Get object(s)
- Replace object(s)
- Replace all objects
- Delete object(s)
- Partial update object(s)
- Clear objects

### Index + Search

- Search
- Browse

### Index + Settings

- Get settings
- Set settings

### Insights client

- Send event(s)
