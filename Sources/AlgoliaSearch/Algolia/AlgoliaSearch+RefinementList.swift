import AlgoliaFilters
import AlgoliaFoundation
import Foundation

public extension AlgoliaSearch {
  func refinementList(attribute: Attribute,
                      selectionMode: SelectionMode,
                      sort: ((Selectable<Facet>, Selectable<Facet>) -> Bool)? = .none) -> RefinementListViewModel<Facet> {
    if let viewModel = refinementListViewModels[attribute] {
      return viewModel
    }
    let viewModel = RefinementListViewModel<Facet>(selectionMode: selectionMode,
                                                   sort: sort)

    let updateSelectedFacets: (Set<Facet>) -> Void

    switch selectionMode {
    case .multiple(isDisjunctive: true):
      let group = OrFilterGroup<FacetFilter>()
      filters.add(group: group, forName: attribute.rawValue)
      updateSelectedFacets = { selectedFacets in
        group.removeAll()
        selectedFacets
          .map { FacetFilter(attribute: attribute, stringValue: $0.value) }
          .forEach(group.add)
      }
    default:
      let group = AndFilterGroup()
      filters.add(group: group, forName: attribute.rawValue)
      updateSelectedFacets = { selectedFacets in
        group.removeAll()
        selectedFacets
          .map { FacetFilter(attribute: attribute, stringValue: $0.value) }
          .forEach(group.add)
      }
    }

    $latestResponse
      .receive(on: DispatchQueue.main)
      .sink { [weak viewModel] response in
        if let rawFacets = response?.searchResponse.facets[attribute.rawValue] {
          viewModel?.setValues([Facet](facetDictionary: rawFacets))
        }
      }
      .store(in: &cancellables)

    viewModel
      .$selectedValues
      .sink(receiveValue: updateSelectedFacets)
      .store(in: &cancellables)
    refinementListViewModels[attribute] = viewModel
    return viewModel
  }
}
