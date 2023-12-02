import Combine
import Foundation

public final class HierarchicalListViewModel<Value>: ObservableObject {
  @Published public var values: [Selectable<Indented<Value>>]

  public var didToggle: PassthroughSubject<Value, Never>

  public init(values: [Selectable<Indented<Value>>] = []) {
    self.values = values
    didToggle = .init()
  }

  public func toggle(_ facet: Value) {
    didToggle.send(facet)
  }
}
