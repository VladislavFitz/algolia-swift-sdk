# Algolia Search client

The Algolia Search client is a software development kit (SDK) that allows developers to easily integrate Algolia's search engine into their Swift applications.
It provides a set of APIs and tools that developers can use to interact with Algolia's search and indexing API using Swift programming language. 
With this library, developers can easily create and update Algolia indices, as well as search and retrieve data from them using various search parameters.

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

## Implemented methods

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
