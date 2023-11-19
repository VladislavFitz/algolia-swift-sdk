import AlgoliaFoundation
import Foundation
import Combine
import OSLog

/// Disjunctive filter group сombines filters with the logical operator "or".
/// Can contain filters of the same type only (facet, numeric or tag).
public final class OrFilterGroup<GroupFilter: Filter>: FilterGroup {
  
  @Published public private(set) var filters: [any Filter]
  
  @Published public var rawValue: String

  public var filtersPublisher: Published<[Filter]>.Publisher { $filters }
  public var rawValuePublisher: Published<String>.Publisher { $rawValue }
  
  public var typedFilters: [GroupFilter] {
    didSet {
      filters = typedFilters
    }
  }
    
  private let logger: Logger
  private var cancellables: Set<AnyCancellable> = []

  public var isEmpty: Bool {
    return filters.isEmpty
  }

  public init(filters: [GroupFilter] = []) {
    self.filters = filters
    self.typedFilters = filters
    self.rawValue = RawFilterTransformer.transform(filters, separator: .or)
    self.logger = Logger(subsystem: "Filters", category: "OrFilterGroup")
    setupSubscriptions()
  }
  
  private func setupSubscriptions() {
    $filters
      .map { filters in
        RawFilterTransformer.transform(filters, separator: .or)
      }
      .assign(to: \.rawValue, on: self)
      .store(in: &cancellables)
    
    $filters
      .sink(receiveValue: { [weak self] filters in
        guard let self else { return }
        self.logger.debug("\(filters)")
      })
      .store(in: &cancellables)
  }

  public func filters(withAttribute attribute: Attribute) -> [any Filter] {
    typedFilters.filter { $0.attribute == attribute }
  }

  public func add(_ filter: GroupFilter) {
    typedFilters.append(filter)
  }

  /// Remove filter from the group
  public func remove(_ filter: GroupFilter) {
    typedFilters.removeAll {
      $0 == filter
    }
  }

  public func removeFilters(withAttribute attribute: Attribute) {
    typedFilters.removeAll { $0.attribute == attribute }
  }

  public func removeAll() {
    typedFilters.removeAll()
  }
}

extension OrFilterGroup: CustomStringConvertible {
  /// Textual representation of the group accepted by Algolia API
  public var description: String {
    RawFilterTransformer.transform(self)
  }
}
