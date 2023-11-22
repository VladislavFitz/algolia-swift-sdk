import Combine
import Foundation

public final class HierarchicalListViewModel<Value>: ObservableObject {
  @Published public var values: [HierarchicalNode<Value>]

  public var didToggle: PassthroughSubject<Value, Never>

  public init(values: [HierarchicalNode<Value>] = []) {
    self.values = values
    didToggle = .init()
  }

  public func toggle(_ facet: Value) {
    didToggle.send(facet)
  }
}
