import Foundation
import AlgoliaFoundation
import AlgoliaFilters

public extension AlgoliaSearch {
  
  func hierarchicalListViewModel(attributesPrefix: String,
                                 attributesRange: ClosedRange<Int>,
                                 separator: String = " > ") -> HierarchicalListViewModel<Facet> {
    
    if let viewModel = hierarchicalListViewModels[attributesPrefix] {
      return viewModel
    }
    
    let filterGroup = HierarchicalFilterGroup(attributesPrefix: attributesPrefix,
                                              attributesRange: attributesRange,
                                              separator: separator)
    filters.add(group: filterGroup,
                forName: attributesPrefix)
    let viewModel = HierarchicalListViewModel<Facet>()
    
    viewModel
      .didToggle
      .receive(on: DispatchQueue.main)
      .map(\.value)
      .sink { [weak filterGroup] facetValue in
        filterGroup?.apply(facetValue)
      }
      .store(in: &cancellables)
    
    $latestResponse
      .receive(on: DispatchQueue.main)
      .map { response in
        let rawFacets = response?.searchResponse.facets ?? [:]
        return [Attribute: [Facet]](rawFacets: rawFacets)
      }
      .map { [weak filterGroup] facets in
        guard let filterGroup else {
          return []
        }
        return filterGroup
          .visibleAttributes
          .compactMap { facets[$0] }
          .enumerated()
          .flatMap { index, values in
            values.map { HierarchicalNode(value: $0,
                                          isSelected: filterGroup.selections.contains($0.value),
                                          indentationLevel: index) }
          }
          .sorted(by: { a, b in
            a.value.value < b.value.value
          })
      }
      .assign(to: \.values, on: viewModel)
      .store(in: &cancellables)
    hierarchicalListViewModels[attributesPrefix] = viewModel
    return viewModel
  }
  
}
