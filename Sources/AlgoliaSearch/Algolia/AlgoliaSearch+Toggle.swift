import AlgoliaFilters
import AlgoliaFoundation
import Foundation

public extension AlgoliaSearch {
  func toggleViewModel(attribute: Attribute) -> ToggleViewModel {
    if let viewModel = toggleViewModels[attribute] {
      return viewModel
    }
    let viewModel = ToggleViewModel(isOn: false)
    let group = AndFilterGroup()
    filters.add(group: group, forName: attribute.rawValue)
    let filter = FacetFilter(attribute: attribute, value: "true")
    viewModel
      .$isOn
      .sink { [weak group] isOn in
        guard let group else { return }
        if isOn {
          group.add(filter)
        } else {
          group.remove(filter)
        }
      }
      .store(in: &cancellables)
    toggleViewModels[attribute] = viewModel
    return viewModel
  }
}
