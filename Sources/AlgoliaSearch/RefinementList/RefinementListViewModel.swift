import Foundation

public final class RefinementListViewModel<Value: Hashable>: ObservableObject {
  let selectionMode: SelectionMode

  @Published
  public private(set) var values: [Value]

  @Published
  private(set) var selectedValues: Set<Value>

  private let sort: ((Value, Value) -> Bool)?

  public init(values: [Value] = [],
              selectedValues: Set<Value> = [],
              selectionMode: SelectionMode = .multiple,
              sort: ((Value, Value) -> Bool)? = .none) {
    self.values = values
    self.selectedValues = selectedValues
    self.selectionMode = selectionMode
    self.sort = sort
  }

  func setValues(_ values: [Value]) {
    if let sort {
      self.values = values.sorted(by: sort)
    } else {
      self.values = values
    }
  }

  public func isSelected(_ value: Value) -> Bool {
    selectedValues.contains(value)
  }

  public func toggle(value: Value) {
    switch (selectionMode, selectedValues.contains(value)) {
    case (.single, false):
      selectedValues.removeAll()
      selectedValues.insert(value)
    case (.single, true):
      selectedValues.removeAll()
    case (.multiple, false):
      selectedValues.insert(value)
    case (.multiple, true):
      selectedValues.remove(value)
    }
  }
}
