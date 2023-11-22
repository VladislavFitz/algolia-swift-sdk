import AlgoliaFilters
import AlgoliaFoundation
import Foundation

public extension AlgoliaSearch {
  func rangeViewModel(attribute: Attribute) -> RangeFilterViewModel {
    if let viewModel = rangeViewModels[attribute] {
      return viewModel
    }
    let viewModel = RangeFilterViewModel(bounds: 0 ... 5000, value: 0 ... 5000)
    let group = AndFilterGroup()
    filters.add(group: group, forName: attribute.rawValue)
    viewModel
      .$value
      .sink { range in
        let range = ClosedRange(uncheckedBounds: (lower: Double(range.lowerBound),
                                                  upper: Double(range.upperBound)))
        group.removeAll()
        group.add(NumericFilter(attribute: attribute,
                                range: range))
      }
      .store(in: &cancellables)
    rangeViewModels[attribute] = viewModel
    return viewModel
  }
}
