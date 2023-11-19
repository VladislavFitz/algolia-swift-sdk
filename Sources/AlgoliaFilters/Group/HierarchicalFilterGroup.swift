import AlgoliaFoundation
import Foundation
import Combine
import OSLog

public final class HierarchicalFilterGroup: FilterGroup {
  
  @Published public private(set) var filters: [any Filter]
  
  public var filtersPublisher: Published<[Filter]>.Publisher { $filters }
  
  @Published public var rawValue: String
  
  public var rawValuePublisher: Published<String>.Publisher { $rawValue }
  
  public var isEmpty: Bool {
    filters.isEmpty
  }
  
  @Published public var hierarchicalFilters: [FacetFilter]
  
  public let attributes: [Attribute]
  public let separator: String
  public var selections: [String] {
    hierarchicalFilters.map(\.value.description)
  }
  
  public var visibleAttributes: [Attribute] {
    //need to fetch the next level of hierarchical facets, so prefix the successor of current number of selections
    let hierarchicalDepth = selections.count + 1
    return Array(attributes.prefix(upTo: hierarchicalDepth))
  }
  
  private let logger: Logger
  private var cancellables: Set<AnyCancellable> = []
    
  public init(attributes: [Attribute],
              separator: String = " > ") {
    self.attributes = attributes
    self.separator = separator
    self.hierarchicalFilters = []
    self.filters = []
    self.rawValue = ""
    self.logger = Logger(subsystem: "Filters", 
                         category: "HierarchicalFilterGroup")
    setupSubscriptions()
  }
  
  public convenience init(attributesPrefix: String,
                          attributesRange: ClosedRange<Int>,
                          separator: String = " > ") {
    let attributes = attributesRange.map{ Attribute(rawValue: "\(attributesPrefix)\($0)") }
    self.init(attributes: attributes,
              separator: separator)
  }

  
  public func apply(_ value: String) {
    let computedSelections = Self.selections(from: value, separator: separator)
    if computedSelections == selections {
      hierarchicalFilters.removeLast()
    } else {
      hierarchicalFilters = Self.makeFilters(attributes: attributes, values: computedSelections)
    }
  }
  
  private func setupSubscriptions() {
    $hierarchicalFilters
      .map { filters in
        [filters.last].compactMap { $0 }
      }
      .sink { [weak self] filters  in
        self?.filters = filters
      }
      .store(in: &cancellables)
    
    $filters
      .map { filters in
        RawFilterTransformer.transform(filters, separator: .and)
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
  
  public func filters(withAttribute attribute: AlgoliaFoundation.Attribute) -> [any Filter] {
    hierarchicalFilters.filter { $0.attribute == attribute }
  }
  
  public func removeFilters(withAttribute attribute: AlgoliaFoundation.Attribute) {
    hierarchicalFilters.removeAll { $0.attribute == attribute }
  }
  
  public func removeAll() {
    hierarchicalFilters.removeAll()
  }
  
  public var description: String {
    RawFilterTransformer.transform(self)
  }
  
}

private extension HierarchicalFilterGroup {
  
  static func makeFilters(attributes: [Attribute], values: [String]) -> [FacetFilter] {
    zip(attributes, values)
      .map {
        FacetFilter(attribute: $0,
                    stringValue: $1)
      }
  }
  
  static func selections(from hierachicalFacetValue: String, separator: String) -> [String] {
    hierachicalFacetValue
      .components(separatedBy: separator)
      .reduce([]) { paths, component in
        let newPath = paths.last.flatMap { $0 + separator + component } ?? component
        return paths + [newPath]
      }
  }
  
}


