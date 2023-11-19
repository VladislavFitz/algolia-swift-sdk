//
//  HierarchicalViewModel.swift
//
//
//  Created by Vladislav Fitc on 18.11.2023.
//

import Foundation
import AlgoliaFoundation
import AlgoliaFilters
import AlgoliaSearchClient

public final class HierarchicalViewModel: ObservableObject {
  
  @Published public var values: [HierarchicalNode<Facet>]
  @Published public var input: HierarchicalInput
  
  private let attributes: [Attribute]
  private let separator: String
  private var selections: [String]
    
  public init(attributes: [Attribute],
              separator: String,
              selections: [String] = [],
              values: [HierarchicalNode<Facet>] = []) {
    self.attributes = attributes
    self.separator = separator
    self.selections = selections
    self.values = values
    self.input = .init(attributes: attributes,
                       filters: HierarchicalViewModel.makeFilters(attributes: attributes, values: selections))
  }
  
  @available(iOS 16.0, *)
  public func title(of facet: Facet) -> String {
    facet.value.split(separator: separator).last.flatMap(String.init) ?? ""
  }
  
  public func toggle(_ facet: Facet) {
    let computedSelections = HierarchicalViewModel.selections(from: facet.value, separator: separator)
    
    if selections == computedSelections {
      selections.removeLast()
    } else {
      selections = computedSelections
    }
    input = .init(attributes: attributes, 
                  filters: HierarchicalViewModel.makeFilters(attributes: attributes, values: selections))
  }
    
  public func update(_ rawFacets: [String: [String: Int]]) {
    values = attributes
      .prefix(selections.count + 1)
      .compactMap { rawFacets[$0.rawValue] }
      .map([Facet].init)
      .enumerated()
      .flatMap { index, values in
        values.map { HierarchicalNode(value: $0,
                                      isSelected: selections.contains($0.value),
                                      indentationLevel: index) }
      }.sorted(by: { a, b in
        a.value.value < b.value.value
      })
  }
    
}

private extension HierarchicalViewModel {
  
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

public struct HierarchicalNode<Value> {
  
  public let value: Value
  public let isSelected: Bool
  public let indentationLevel: Int
  
  public init(value: Value,
              isSelected: Bool = false,
              indentationLevel: Int = 0) {
    self.value = value
    self.isSelected = isSelected
    self.indentationLevel = indentationLevel
  }
  
}


public struct HierarchicalInput {
  
  public let attributes: [Attribute]
  public let filters: [FacetFilter]
  
  public init(attributes: [Attribute], filters: [FacetFilter]) {
    self.attributes = attributes
    self.filters = filters
  }
  
  public static let empty = Self(attributes: [], filters: [])
  
}

fileprivate extension Array<Facet> {
  
  init(facetDictionary: [String: Int]) {
    self = facetDictionary.map { value, count in
      Facet(value: value, count: count)
    }
  }
  
}
