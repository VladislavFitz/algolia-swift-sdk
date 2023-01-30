// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "AlgoliaSDK",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .watchOS(.v2),
    .tvOS(.v9)
  ],
  products: [
    .library(
      name: "TestHelper",
      targets: ["TestHelper"]
    ),
    .library(
      name: "AlgoliaFoundation",
      targets: ["AlgoliaFoundation"]
    ),
    .library(
      name: "AlgoliaSearchClient",
      targets: ["AlgoliaSearchClient"]
    ),
    .library(
      name: "AlgoliaInsightsClient",
      targets: ["AlgoliaInsightsClient"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
  ],
  targets: [
    .target(
      name: "AlgoliaFoundation",
      dependencies: [
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .target(
      name: "TestHelper",
      dependencies: [
        .target(name: "AlgoliaFoundation")
      ]
    ),
    .target(
      name: "AlgoliaSearchClient",
      dependencies: [
        .target(name: "AlgoliaFoundation"),
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .target(
      name: "AlgoliaInsightsClient",
      dependencies: [
        .target(name: "AlgoliaFoundation"),
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .testTarget(
      name: "AlgoliaFoundationTests",
      dependencies: [
        .target(name: "AlgoliaFoundation"),
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .testTarget(
      name: "AlgoliaSearchClientTests",
      dependencies: [
        .target(name: "AlgoliaFoundation"),
        .target(name: "AlgoliaSearchClient"),
        .target(name: "TestHelper"),
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .testTarget(
      name: "AlgoliaInsightsClientTests",
      dependencies: [
        .target(name: "AlgoliaFoundation"),
        .target(name: "AlgoliaSearchClient"),
        .target(name: "AlgoliaInsightsClient"),
        .target(name: "TestHelper"),
        .product(name: "Logging", package: "swift-log")
      ]
    )
  ]
)
