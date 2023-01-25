import Foundation

/// Snippet result for an attribute of a hit.
public struct SnippetResult: Codable, Hashable {
  /// Value of this snippet.
  public let value: String

  /// Match level.
  public let matchLevel: MatchLevel
}
