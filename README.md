# Algolia Swift API client

Unofficial Algolia Swift API client using the latest Swift features to provide the best developer experience.

- Pure Swift client
- Implements Algolia retry strategy
- All the methods are async
- Convenient `wait()` methods for asynchronous backend tasks
- Uses the result builder for search and settings parameters

## Install

### Swift Package Manager

The Swift Package Manager is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.
Since the release of Swift 5 and Xcode 11, SPM is compatible with the iOS,
macOS and tvOS build systems for creating apps.

To use SwiftPM, you should use Xcode 11 to open your project. Click `File` -> `Swift Packages`
-> `Add Package Dependency`, enter `github.com/VladislavFitz/algoliasearch-client-swift-modern`

If you're a framework author and use Swift API Client as a dependency, update your `Package.swift` file:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/VladislavFitz/algoliasearch-client-swift-modern", from: "0.1.0")
    ],
    // ...
)
```

## Getting started

### Initialize the client

To start, you need to initialize the client. To do this, you need your **Application ID** and **API Key**.
You can find both on [your Algolia account](https://www.algolia.com/api-keys).

```swift
let client = Client(appID: "YourApplicationID", apiKey: "YourAdminAPIKey")
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
- Save object/objects
- Get object/objects
- Replace object/objects
- Replace all objects
- Delete object/objects
- Partial update object/objects
- Clear objects

### Index + Search

- Search
- Browse

### Index + Settings

- Get settings
- Set settings
