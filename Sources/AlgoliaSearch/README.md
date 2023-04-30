# Algolia Search Library for Swift

This Swift library provides a simple and efficient way to interact with the Algolia search engine. It offers a set of classes and protocols to build customizable search experiences within your Apple platform applications.

## Features

- Easy-to-use `AlgoliaSearch` class for performing search requests
- Customizable search requests and responses
- Pagination support
- SwiftUI components for displaying search results
- Concurrency and performance optimizations

## Installation

To install the Algolia Search Library, you can use the Swift Package Manager by adding the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/VladislavFitz/algolia-swift-sdk/", .upToNextMajor(from: "0.4.0"))
]
```

## Usage

### Importing the library

To use the library, simply import it in the files where you want to interact with the Algolia search engine:

```swift
import AlgoliaSearch
```

### Initializing the AlgoliaSearch class

First, create an instance of the `AlgoliaSearch` class by providing your Algolia application ID, API key, and the name of the index you want to search:

```swift
let algoliaSearch = AlgoliaSearch<CustomDecodableItem>(
    applicationID: "YourApplicationID",
    apiKey: "YourAPIKey",
    indexName: "YourIndexName"
)
```

Make sure that the CustomDecodableItem type conforms to the Decodable protocol and matches the structure of the records in your Algolia index.

### Performing a search request

To perform a search request, simply update the `request` property of your `AlgoliaSearch` instance:

```swift
algoliaSearch.request.searchParameters.query = "YourSearchQuery"
```

The library will automatically handle the search request and update the `hits` property with the search results.

### Displaying search results

To display the search results, you can use the provided `InfiniteList` SwiftUI component. Just pass your `InifiniteListViewModel` instance and provide two view builders, one for each item in the search results and one for when there are no results:

```swift
InfiniteList(algoliaSearch.hits,
             hitView: { (item: CustomDecodableItem) in
              Text(item.title)
             },
             noResults: {
              Text("No results found.")
             })
```
