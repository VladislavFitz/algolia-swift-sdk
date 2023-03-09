[![swift](https://img.shields.io/badge/Swift-5.6-orange)](https://www.swift.org)
[![test](https://github.com/VladislavFitz/algolia-swift-sdk/actions/workflows/test.yml/badge.svg)](https://github.com/VladislavFitz/algolia-swift-sdk/actions/workflows/test.yml)
![platform](https://img.shields.io/badge/platforms-iOS_13+%20%7C%20macOS_10.15+%20%7C%20tvOS_13+%20%7C%20watchOS_6+-blue.svg?style=flat")
[![MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Algolia Swift SDK

Unofficial Algolia Swift SDK built by Algolia employee.
Adopts the latest Swift features and provides the best developer experience.

- Pure Swift SDK
- Implements the Algolia retry strategy for network requests
- Covered by official Algolia API clients test suite
- Adopts the modern Swift concurrency
- Uses Combine for state mangement
- Uses the result builder for search and settings parameters
- Provides convenient `wait()` methods for asynchronous backend tasks

## Contents

- [Algolia Search client](/Sources/AlgoliaSearchClient) - library that allows developers to interact with Algolia's search and indexing API using Swift. The library provides a set of APIs and tools for performing various search and indexing operations on Algolia indices, as well as support for advanced search features such as faceting and geo-search. It offers a strongly typed API and built-in error handling and response parsing capabilities, making it easy to create fast and relevant search experiences for users.

- [Algolia Insights client](/Sources/AlgoliaInsightsClient) - API client for the [Insights requests](https://www.algolia.com/doc/api-client/methods/insights/) which lets you capture click, conversion, and view events to help you understand how your users interact with your search and discovery experience.

- [Algolia Filters](Sources/AlgoliaFilters) - library that provides  building blocks for creating and combining filters for Algolia Search. It offers a convenient, strongly typed API for modifying and updating the state of filters. The library ensures that the resulting filter expression is always valid and can be used as a search parameter.

## Install

### Swift Package Manager

The Swift Package Manager is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

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
