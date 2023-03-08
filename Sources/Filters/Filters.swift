import Foundation
import AlgoliaFoundation

final class Filters: ObservableObject {

  /// Map of filter groups per string identifier
  @Published var groups: [String: any FilterGroup]

  init(groups: [String: any FilterGroup] = [:]) {
    self.groups = groups
  }

}

extension Filters: CustomStringConvertible {

  /// Textual representation of the group accepted by Algolia API
  var description: String {
    groups.values.map(\.description).joined(separator: " AND ")
  }

}
