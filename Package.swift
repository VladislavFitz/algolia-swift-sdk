// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AlgoliaSearchClientSwiftModern",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .watchOS(.v2),
    .tvOS(.v9)
  ],
  products: [
    .library(
      name: "AlgoliaSearchClientSwiftModern",
      targets: ["AlgoliaSearchClientSwiftModern"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
  ],
  targets: [
    .target(
      name: "AlgoliaSearchClientSwiftModern",
      dependencies: [
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .testTarget(
      name: "AlgoliaSearchClientSwiftModernTests",
      dependencies: [
        .target(name: "AlgoliaSearchClientSwiftModern"),
        .product(name: "Logging", package: "swift-log")
      ]
    )
  ]
)
