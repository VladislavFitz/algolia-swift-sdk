import AlgoliaFoundation
import Foundation
import Combine
import OSLog

/// Conjunctive filter group сombines filters with the logical operator "and".
/// Can contain filters of different types at the same time.
public final class AndFilterGroup: FilterGroup {
  
  @Published public private(set) var filters: [any Filter]
  
  @Published public var rawValue: String

  public var filtersPublisher: Published<[Filter]>.Publisher { $filters }
  public var rawValuePublisher: Published<String>.Publisher { $rawValue }

  private let logger: Logger
  private var cancellables: Set<AnyCancellable> = []

  public var isEmpty: Bool {
    return filters.isEmpty
  }

  public init(filters: [any Filter] = []) {
    self.filters = filters
    self.logger = Logger(subsystem: "Filters", category: "AndFilterGroup")
    self.rawValue = RawFilterTransformer.transform(filters, separator: .and)
    setupSubscriptions()
  }

  public func filters(withAttribute attribute: Attribute) -> [any Filter] {
    filters.filter { $0.attribute == attribute }
  }

  public func add(_ filter: any Filter) {
    filters.append(filter)
  }

  /// Remove filter from the group
  public func remove<F: Filter>(_ filter: F) {
    filters.removeAll {
      ($0 as? F) == filter
    }
  }

  public func removeFilters(withAttribute attribute: Attribute) {
    filters.removeAll { $0.attribute == attribute }
  }

  public func removeAll() {
    filters.removeAll()
  }
  
  private func setupSubscriptions() {
    $filters
      .map { filters in
        RawFilterTransformer.transform(filters, separator: .and)
      }
      .assign(to: \.rawValue, on: self)
      .store(in: &cancellables)
    
    $filters
      .sink { [weak self] filters in
        guard let self else { return }
        self.logger.debug("\(filters)")
      }
      .store(in: &cancellables)
  }
}

public extension AndFilterGroup {
  /// Textual representation of the group accepted by Algolia API
  var description: String {
    RawFilterTransformer.transform(self)
  }
}

