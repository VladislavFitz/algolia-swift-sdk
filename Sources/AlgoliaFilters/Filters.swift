import AlgoliaFoundation
import OSLog
import Foundation
import Combine

public final class Filters: ObservableObject {
  /// Map of filter groups per string identifier
  @Published public private(set) var groups: [String: any FilterGroup]

  @Published public var isEmpty: Bool
  @Published public var rawValue: String

  private let logger: Logger

  private var cancellables: Set<AnyCancellable> = []

  public init(groups: [String: any FilterGroup] = [:]) {
    self.groups = groups
    self.isEmpty = groups.values.map(\.isEmpty).allSatisfy { $0 == true }
    self.logger = Logger(subsystem: "Filters", category: "Filters")
    self.rawValue = RawFilterTransformer.transform(groups.values, separator: .and)
    setupSubscriptions()
  }

  public func add(group: AndFilterGroup, forName name: String) {
    groups[name] = group
    setupSubscriptions()
  }

  public func add<F: Filter>(group: OrFilterGroup<F>, forName name: String) {
    groups[name] = group
    setupSubscriptions()
  }

  public func add(group: HierarchicalFilterGroup, forName name: String) {
    groups[name] = group
    setupSubscriptions()
  }

  public func removeAll() {
    groups.values.forEach { group in
      group.removeAll()
    }
  }

  private func setupSubscriptions() {
    cancellables.forEach { $0.cancel() }
    let initialPublisher: AnyPublisher<[String], Never> = Just([]).eraseToAnyPublisher()
    groups
      .values
      .map(\.rawValuePublisher)
      .reduce(initialPublisher) { combined, publisher in
        combined
          .combineLatest(publisher).map { $0.0 + [$0.1] }
          .eraseToAnyPublisher()
      }
      .map { groupsRawValues in
        groupsRawValues
          .filter { !$0.isEmpty }
          .sorted()
          .joined(separator: " AND ")
      }
      .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
      .assign(to: \.rawValue, on: self)
      .store(in: &cancellables)

    $rawValue
      .map(\.isEmpty)
      .assign(to: \.isEmpty, on: self)
      .store(in: &cancellables)
  }

}

extension Filters: CustomStringConvertible {
  /// Textual representation of the group accepted by Algolia API
  public var description: String {
    RawFilterTransformer.transform(self)
  }
}
