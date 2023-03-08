import AlgoliaFoundation
import Foundation

public final class Filters: ObservableObject {
  /// Map of filter groups per string identifier
  @Published public var groups: [String: any FilterGroup]

  public init(groups: [String: any FilterGroup] = [:]) {
    self.groups = groups
  }
}

extension Filters: CustomStringConvertible {
  /// Textual representation of the group accepted by Algolia API
  public var description: String {
    groups.values.map(\.description).sorted().joined(separator: " AND ")
  }
}
